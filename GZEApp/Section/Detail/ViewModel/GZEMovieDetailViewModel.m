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
        self.reqCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *videoSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
                req.movieId = movieId;
                req.type = GZEMovieDetailType_Video;
                WeakSelf(self)
                [req startRequestWithRspClass:[GZETmdbVideoRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
                    StrongSelfReturnNil(self)
                    if (isSuccess) {
                        GZETmdbVideoRsp *response = (GZETmdbVideoRsp *)rsp;
                        response.results = [self reOrganizeVideos:response.results];
                        self.videos = response;
                        // 请求首个视频信息展示在详情页
                        GZETmdbVideoItem *item = response.results.firstObject;
                        if (item) {
                            GZEYTVideoReq *videoReq = [[GZEYTVideoReq alloc] init];
                            videoReq.v = item.key;
                            videoReq.withoutApiKey = YES;
                            WeakSelf(self)
                            [videoReq startRequestWithRspClass:[GZEYTVideoRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
                                StrongSelfReturnNil(self)
                                if (isSuccess) {
                                    GZEYTVideoRsp *videoRsp = (GZEYTVideoRsp *)rsp;
                                    videoRsp.videoType = item.type;
                                    self.firstVideo = videoRsp;
                                }
                            }];
                        }
                    }
                }];
                return nil;
            }];
            
            
            return [RACSignal combineLatest:@[]];
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
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = self.movieId;
        req.type = GZEMovieDetailType_Common;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieDetailRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieDetailRsp *response = (GZEMovieDetailRsp *)rsp;
                self.commonInfo = response;
                // 额外计算一个魔法色
                WeakSelf(self)
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[GZECommonHelper getPosterUrl:response.posterPath size:GZEPosterSize_w185] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    StrongSelfReturnNil(self)
                    if (image) {
                        self.magicColor = [image magicColor];
                    } else {
                        self.magicColor = RGBColor(0, 191, 255);
                    }
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
            }
        }];
        return nil;
    }];;
}

- (RACSignal *)crewCastSignal
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = self.movieId;
        req.type = GZEMovieDetailType_CrewCast;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZECrewCastRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZECrewCastRsp *response = (GZECrewCastRsp *)rsp;
                self.crewCast = response;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

@end
