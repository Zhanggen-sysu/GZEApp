//
//  GZEMovieDetailViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
@class GZEMovieCrewCastRsp;
@class GZEMovieReviewRsp;
@class GZEMovieImageRsp;
@class GZEMovieDetailRsp;
@class GZEMovieListRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieDetailViewModel : GZEBaseModel

@property (nonatomic, strong) GZEMovieCrewCastRsp *crewCast;
@property (nonatomic, strong) GZEMovieDetailRsp *commonInfo;
@property (nonatomic, strong) GZEMovieImageRsp *images;
@property (nonatomic, strong) GZEMovieReviewRsp *reviews;
@property (nonatomic, strong) GZEMovieListRsp *similar;

@end

NS_ASSUME_NONNULL_END
