//
//  GZEMovieDetailViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEMovieDetailViewModel.h"
#import "GZEDetailListViewVM.h"
#import "GZEMovieDetailReq.h"
#import "GZEMovieDetailRsp.h"
#import "GZETmdbVideoRsp.h"
#import "GZETmdbImageRsp.h"
#import "GZEKeywordRsp.h"
#import "GZEMovieListRsp.h"
#import "GZETmdbReviewRsp.h"
#import "GZECrewCastRsp.h"
#import "GZEYTVideoRsp.h"
#import "GZEYTVideoReq.h"
#import "GZETmdbVideoItem.h"
#import "SDWebImageDownloader.h"
#import "GZECommonHelper.h"
#import "UIImage+magicColor.h"

@interface GZEMovieDetailViewModel ()

@property (nonatomic, strong, readwrite) GZEMovieDetailRsp *commonInfo;
@property (nonatomic, strong, readwrite) GZECrewCastRsp *crewCast;
@property (nonatomic, strong, readwrite) GZETmdbImageRsp *images;
@property (nonatomic, strong, readwrite) GZETmdbReviewRsp *reviews;
@property (nonatomic, strong, readwrite) GZEMovieListRsp *similar;
@property (nonatomic, strong, readwrite) GZEMovieListRsp *recommend;
@property (nonatomic, strong, readwrite) GZETmdbVideoRsp *videos;
@property (nonatomic, strong, readwrite) GZEYTVideoRsp *firstVideo;
@property (nonatomic, strong, readwrite) GZEKeywordRsp *keyword;
@property (nonatomic, strong, readwrite) UIColor *magicColor;
@property (nonatomic, strong, readwrite) GZEDetailListViewVM *similarVM;
@property (nonatomic, strong, readwrite) GZEDetailListViewVM *recommendVM;

@property (nonatomic, strong, readwrite) RACCommand *reqCommand;

@property (nonatomic, assign, readwrite) NSInteger movieId;

@end

@implementation GZEMovieDetailViewModel

- (instancetype)initWithMovieId:(NSInteger)movieId
{
    if (self = [super init]) {
        self.movieId = movieId;
        WeakSelf(self)
        self.reqCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            StrongSelf(self)
            if (!self)return [RACSignal empty];
            return [RACSignal combineLatest:@[self.detailSignal, self.crewCastSignal, self.videoSignal, self.imageSignal, self.keywordSignal, self.reviewSignal, self.similarSignal, self.recommendSignal]];
        }];
        [[[RACSignal combineLatest:@[RACObserve(self, magicColor), RACObserve(self, similar)]] skip:2] subscribeNext:^(RACTuple * _Nullable x) {
            StrongSelf(self)
            if (!self)return;
            self.similarVM = [[GZEDetailListViewVM alloc] initWithTitle:@"Recommend For You" movieListRsp:self.similar magicColor:self.magicColor];
        }];
        [[[RACSignal combineLatest:@[RACObserve(self, magicColor), RACObserve(self, recommend)] ] skip:2] subscribeNext:^(RACTuple * _Nullable x) {
            StrongSelf(self)
            if (!self)return;
            self.recommendVM = [[GZEDetailListViewVM alloc] initWithTitle:@"More Like This" movieListRsp:self.recommend magicColor:self.magicColor];
        }];
    }
    return self;
}

- (NSArray<GZETmdbVideoItem *> *)reOrganizeVideos:(NSArray<GZETmdbVideoItem *> *)videos
{
    NSMutableArray *trailer = [[NSMutableArray alloc] init];
    NSMutableArray *valid = [[NSMutableArray alloc] init];
    [videos enumerateObjectsUsingBlock:^(GZETmdbVideoItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.site isEqualToString:@"YouTube"]) {
            if ([obj.type isEqualToString:@"Trailer"]) {
                [trailer addObject:obj];
            } else {
                [valid addObject:obj];
            }
        }
    }];
    if (trailer.count > 0) {
        NSRange range = NSMakeRange(0, [trailer count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [valid insertObjects:trailer atIndexes:indexSet];
    }
    return valid;
}

- (RACSignal *)detailSignal
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = self.movieId;
        req.type = GZEMovieDetailType_Common;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieDetailRsp class]
               completeWithErrorBlock:^(BOOL isSuccess, id  _Nullable rsp, NSError * _Nullable error) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieDetailRsp *response = (GZEMovieDetailRsp *)rsp;
                self.commonInfo = response;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }] then:^RACSignal * _Nonnull{
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            // 额外计算一个魔法色
            WeakSelf(self)
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[GZECommonHelper getPosterUrl:self.commonInfo.posterPath size:GZEPosterSize_w185] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                StrongSelfReturnNil(self)
                if (image) {
                    self.magicColor = [image magicColor];
                } else {
                    self.magicColor = RGBColor(0, 191, 255);
                }
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
}

- (RACSignal *)crewCastSignal
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = self.movieId;
        req.type = GZEMovieDetailType_CrewCast;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZECrewCastRsp class] completeWithErrorBlock:^(BOOL isSuccess, id  _Nullable rsp, NSError * _Nullable error) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZECrewCastRsp *response = (GZECrewCastRsp *)rsp;
                self.crewCast = response;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)videoSignal
{
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = self.movieId;
        req.type = GZEMovieDetailType_Video;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZETmdbVideoRsp class] completeWithErrorBlock:^(BOOL isSuccess, id  _Nullable rsp, NSError * _Nullable error) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZETmdbVideoRsp *response = (GZETmdbVideoRsp *)rsp;
                response.results = [self reOrganizeVideos:response.results];
                self.videos = response;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }] then:^RACSignal * _Nonnull{
        // 请求首个视频信息展示在详情页
        GZETmdbVideoItem *item = self.videos.results.firstObject;
        if (item) {
            GZEYTVideoReq *videoReq = [[GZEYTVideoReq alloc] init];
            videoReq.v = item.key;
            videoReq.withoutApiKey = YES;
            WeakSelf(self)
            [videoReq startRequestWithRspClass:[GZEYTVideoRsp class] completeWithErrorBlock:^(BOOL isSuccess, id  _Nullable rsp, NSError * _Nullable error) {
                StrongSelfReturnNil(self)
                if (isSuccess) {
                    GZEYTVideoRsp *videoRsp = (GZEYTVideoRsp *)rsp;
                    videoRsp.videoType = item.type;
                    self.firstVideo = videoRsp;
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }
            }];
        } else {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }
    }];
}

- (RACSignal *)imageSignal
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = self.movieId;
        req.type = GZEMovieDetailType_Image;
        // 图片不能加语言，标记一下
        req.language = @"";
        WeakSelf(self)
        [req startRequestWithRspClass:[GZETmdbImageRsp class] completeWithErrorBlock:^(BOOL isSuccess, id  _Nullable rsp, NSError * _Nullable error) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZETmdbImageRsp *response = (GZETmdbImageRsp *)rsp;
                self.images = response;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)keywordSignal
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = self.movieId;
        req.type = GZEMovieDetailType_Keyword;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEKeywordRsp class] completeWithErrorBlock:^(BOOL isSuccess, id  _Nullable rsp, NSError * _Nullable error) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEKeywordRsp *response = (GZEKeywordRsp *)rsp;
                self.keyword = response;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

- (RACSignal *)reviewSignal
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = self.movieId;
        req.type = GZEMovieDetailType_Review;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZETmdbReviewRsp class] completeWithErrorBlock:^(BOOL isSuccess, id  _Nullable rsp, NSError * _Nullable error) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZETmdbReviewRsp *response = (GZETmdbReviewRsp *)rsp;
                self.reviews = response;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)similarSignal
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = self.movieId;
        req.type = GZEMovieDetailType_Similar;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieListRsp class] completeWithErrorBlock:^(BOOL isSuccess, id  _Nullable rsp, NSError * _Nullable error) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieListRsp *response = (GZEMovieListRsp *)rsp;
                self.similar = response;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)recommendSignal
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = self.movieId;
        req.type = GZEMovieDetailType_Recommend;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieListRsp class] completeWithErrorBlock:^(BOOL isSuccess, id  _Nullable rsp, NSError * _Nullable error) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieListRsp *response = (GZEMovieListRsp *)rsp;
                self.recommend = response;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

@end
