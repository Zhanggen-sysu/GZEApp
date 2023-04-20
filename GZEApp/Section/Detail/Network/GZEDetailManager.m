//
//  GZEDetailManager.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEDetailManager.h"
#import "GZEMovieDetailRsp.h"
#import "GZECrewCastRsp.h"
#import "GZETmdbImageRsp.h"
#import "GZETmdbReviewRsp.h"
#import "GZEMovieListRsp.h"
#import "GZETmdbVideoRsp.h"
#import "GZEKeywordRsp.h"
#import "GZEMovieDetailViewModel.h"

#import "GZETVDetailViewModel.h"
#import "GZETVDetailRsp.h"

#import "GZEPeopleDetailRsp.h"

#import "Macro.h"
#import "GZECommonHelper.h"
#import "SDWebImageDownloader.h"
#import "UIImage+magicColor.h"
#import "GZETmdbVideoItem.h"
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
            StrongSelf(self)
            if (!self) {
                dispatch_group_leave(group);
                return;
            }
            if (isSuccess) {
                GZEMovieDetailRsp *response = (GZEMovieDetailRsp *)rsp;
                viewModel.commonInfo = response;
                // 额外计算一个魔法色
                WeakSelf(self)
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[GZECommonHelper getPosterUrl:response.posterPath size:GZEPosterSize_w185] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    // TODO: genzhang 如果直接return了怎么办
                    StrongSelf(self)
                    if (!self) {
                        dispatch_group_leave(group);
                        return;
                    }
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
        [req startRequestWithRspClass:[GZECrewCastRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelf(self)
            if (!self) {
                dispatch_group_leave(group);
                return;
            }
            if (isSuccess) {
                GZECrewCastRsp *response = (GZECrewCastRsp *)rsp;
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
        [req startRequestWithRspClass:[GZETmdbVideoRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelf(self)
            if (!self) {
                dispatch_group_leave(group);
                return;
            }
            if (isSuccess) {
                GZETmdbVideoRsp *response = (GZETmdbVideoRsp *)rsp;
                response.results = [self reOrganizeVideos:response.results];
                viewModel.videos = response;
                // 请求首个视频信息展示在详情页
                GZETmdbVideoItem *item = response.results.firstObject;
                if (item) {
                    GZEYTVideoReq *videoReq = [[GZEYTVideoReq alloc] init];
                    videoReq.v = item.key;
                    videoReq.withoutApiKey = YES;
                    WeakSelf(self)
                    [videoReq startRequestWithRspClass:[GZEYTVideoRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
                        StrongSelf(self)
                        if (!self) {
                            dispatch_group_leave(group);
                            return;
                        }
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
        [req startRequestWithRspClass:[GZETmdbImageRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelf(self)
            if (!self) {
                dispatch_group_leave(group);
                return;
            }
            if (isSuccess) {
                GZETmdbImageRsp *response = (GZETmdbImageRsp *)rsp;
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
        req.type = GZEMovieDetailType_Keyword;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEKeywordRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelf(self)
            if (!self) {
                dispatch_group_leave(group);
                return;
            }
            if (isSuccess) {
                GZEKeywordRsp *response = (GZEKeywordRsp *)rsp;
                viewModel.keyword = response;
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
        [req startRequestWithRspClass:[GZETmdbReviewRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelf(self)
            if (!self) {
                dispatch_group_leave(group);
                return;
            }
            if (isSuccess) {
                GZETmdbReviewRsp *response = (GZETmdbReviewRsp *)rsp;
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
            StrongSelf(self)
            if (!self) {
                dispatch_group_leave(group);
                return;
            }
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
            StrongSelf(self)
            if (!self) {
                dispatch_group_leave(group);
                return;
            }
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

- (void)getTVDetailWithId:(NSInteger)tvId completion:(GZECommonRspBlock)completion
{
    GZETVDetailViewModel *viewModel = [[GZETVDetailViewModel alloc] init];
    GZETVDetailReq *req = [[GZETVDetailReq alloc] init];
    req.tvId = tvId;
    req.type = GZETVDetailType_All;
    req.language = @"";
    WeakSelf(self)
    [req startRequestWithRspClass:[GZETVDetailRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
        StrongSelfReturnNil(self)
        if (isSuccess) {
            GZETVDetailRsp *response = (GZETVDetailRsp *)rsp;
            viewModel.detail = response;
            dispatch_group_t group = dispatch_group_create();
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_enter(group);
            dispatch_async(queue, ^{
                // 额外计算一个魔法色
                WeakSelf(self)
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[GZECommonHelper getPosterUrl:response.posterPath size:GZEPosterSize_w185] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    StrongSelf(self)
                    if (!self) {
                        dispatch_group_leave(group);
                        return;
                    }
                    if (image) {
                        viewModel.magicColor = [image magicColor];
                    } else {
                        viewModel.magicColor = RGBColor(0, 191, 255);
                    }
                    dispatch_group_leave(group);
                }];
            });
            dispatch_group_enter(group);
            dispatch_async(queue, ^{
                response.videos.results = [self reOrganizeVideos:response.videos.results];
                // 请求首个视频信息展示在详情页
                GZETmdbVideoItem *item = response.videos.results.firstObject;
                if (item) {
                    GZEYTVideoReq *videoReq = [[GZEYTVideoReq alloc] init];
                    videoReq.v = item.key;
                    videoReq.withoutApiKey = YES;
                    WeakSelf(self)
                    [videoReq startRequestWithRspClass:[GZEYTVideoRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
                        StrongSelf(self)
                        if (!self) {
                            dispatch_group_leave(group);
                            return;
                        }
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
            });
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                !completion ?: completion(YES, viewModel, @"");
            });
        } else {
            [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
            !completion ?: completion(YES, viewModel, @"");
        }
    }];
}

- (void)getPeopleDetailWithId:(NSInteger)peopleId completion:(GZECommonRspBlock)completion
{
    GZEPeopleDetailReq *req = [[GZEPeopleDetailReq alloc] init];
    req.peopleId = peopleId;
    req.language = @"";
    req.type = GZEPeopleDetailType_All;
    req.page = 1;
    WeakSelf(self)
    [req startRequestWithRspClass:[GZEPeopleDetailRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
        StrongSelfReturnNil(self)
        if (isSuccess) {
            GZEPeopleDetailRsp *response = (GZEPeopleDetailRsp *)rsp;
            !completion ?: completion(YES, response, @"");
        } else {
            [GZECommonHelper showMessage:errorMessage inView:nil duration:1.5];
            !completion ?: completion(NO, rsp, @"");
        }
    }];
}

@end
