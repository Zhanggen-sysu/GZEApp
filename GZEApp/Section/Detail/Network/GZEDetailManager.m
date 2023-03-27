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
#import "GZEMovieDetailViewModel.h"
#import "Macro.h"
#import "GZECommonHelper.h"

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
            if (isSuccess) {
                GZEMovieDetailRsp *response = (GZEMovieDetailRsp *)rsp;
                viewModel.commonInfo = response;
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
        req.type = GZEMovieDetailType_CrewCast;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieCrewCastRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
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
        req.type = GZEMovieDetailType_Image;
        WeakSelf(self)
        [req startRequestWithRspClass:[GZEMovieImageRsp class] completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
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
            if (isSuccess) {
                GZEMovieListRsp *response = (GZEMovieListRsp *)rsp;
                viewModel.similar = response;
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

@end
