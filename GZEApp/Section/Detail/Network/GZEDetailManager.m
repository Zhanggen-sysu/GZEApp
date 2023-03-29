//
//  GZEDetailManager.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEDetailManager.h"
#import "GZEMovieDetailRsp.h"
#import "GZEMovieCrewCastRsp.h"
#import "GZEMovieImageRsp.h"
#import "GZEMovieReviewRsp.h"
#import "GZEMovieListRsp.h"
#import "GZEMovieViedeoRsp.h"
#import "GZEMovieDetailViewModel.h"
#import "Macro.h"
#import "GZECommonHelper.h"
#import "SDWebImageDownloader.h"
#import "UIImage+magicColor.h"
#import "GZEMovieVideoItem.h"
#import "GZEYTVideoReq.h"
#import "GZEYTVideoRsp.h"

@implementation GZEDetailManager

- (void)getMovieDetailWithId:(NSInteger)movieId completion:(nonnull GZECommonRspBlock)completion
{
    GZEMovieDetailViewModel *viewModel = [[GZEMovieDetailViewModel alloc] init];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = movieId;
        req.type = GZEMovieDetailType_Common;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieDetailRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieDetailRsp *response = (GZEMovieDetailRsp *)rsp;
                viewModel.commonInfo = response;
                // 额外计算一个魔法色
                WeakSelf(self)
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[GZECommonHelper getPosterUrl:response.posterPath size:GZEPosterSize_w185] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    StrongSelfReturnNil(self)
                    if (image) {
                        viewModel.magicColor = [image magicColor];
                    } else {
                        viewModel.magicColor = RGBColor(0, 191, 255);
                    }
                    dispatch_group_leave(group);
                }];
            } else {
                [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
                dispatch_group_leave(group);
            }
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = movieId;
        req.type = GZEMovieDetailType_CrewCast;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieCrewCastRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieCrewCastRsp *response = (GZEMovieCrewCastRsp *)rsp;
                viewModel.crewCast = response;
            } else {
                [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
            }
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = movieId;
        req.type = GZEMovieDetailType_Video;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieViedeoRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieViedeoRsp *response = (GZEMovieViedeoRsp *)rsp;
                response.results = [self reOrganizeVideos:response.results];
                viewModel.videos = response;
                // 请求首个视频信息展示在详情页
                GZEMovieVideoItem *item = response.results.firstObject;
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
                            viewModel.firstVideo = videoRsp;
                        } else {
                            [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
                        }
                        dispatch_group_leave(group);
                    }];
                } else {
                    dispatch_group_leave(group);
                }
            } else {
                [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
                dispatch_group_leave(group);
            }
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = movieId;
        req.type = GZEMovieDetailType_Image;
        // 图片不能加语言，标记一下
        req.language = @"";
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieImageRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieImageRsp *response = (GZEMovieImageRsp *)rsp;
                viewModel.images = response;
            } else {
                [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
            }
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = movieId;
        req.type = GZEMovieDetailType_Review;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieReviewRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieReviewRsp *response = (GZEMovieReviewRsp *)rsp;
                viewModel.reviews = response;
            } else {
                [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
            }
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = movieId;
        req.type = GZEMovieDetailType_Similar;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieListRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieListRsp *response = (GZEMovieListRsp *)rsp;
                viewModel.similar = response;
            } else {
                [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
            }
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        GZEMovieDetailReq *req = [[GZEMovieDetailReq alloc] init];
        req.movieId = movieId;
        req.type = GZEMovieDetailType_Recommend;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieListRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieListRsp *response = (GZEMovieListRsp *)rsp;
                viewModel.recommend = response;
            } else {
                [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
            }
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        !completion ?: completion(YES, viewModel, @"");
    });
}

// 将预告片放到前面，移除非Youtube视频
- (NSArray<GZEMovieVideoItem *> *)reOrganizeVideos:(NSArray<GZEMovieVideoItem *> *)videos
{
    NSMutableArray *trailer = [[NSMutableArray alloc] init];
    NSMutableArray *valid = [[NSMutableArray alloc] init];
    [videos enumerateObjectsUsingBlock:^(GZEMovieVideoItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

@end
