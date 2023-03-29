//
//  GZEMovieDetailViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
#import <UIKit/UIKit.h>
@class GZEMovieCrewCastRsp;
@class GZEMovieReviewRsp;
@class GZEMovieImageRsp;
@class GZEMovieDetailRsp;
@class GZEMovieListRsp;
@class GZEMovieViedeoRsp;
@class GZEYTVideoRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieDetailViewModel : GZEBaseModel

@property (nonatomic, strong) GZEMovieCrewCastRsp *crewCast;
@property (nonatomic, strong) GZEMovieDetailRsp *commonInfo;
@property (nonatomic, strong) GZEMovieImageRsp *images;
@property (nonatomic, strong) GZEMovieReviewRsp *reviews;
@property (nonatomic, strong) GZEMovieListRsp *similar;
@property (nonatomic, strong) GZEMovieListRsp *recommend;
@property (nonatomic, strong) GZEMovieViedeoRsp *videos;
@property (nonatomic, strong) GZEYTVideoRsp *firstVideo;
@property (nonatomic, strong) UIColor *magicColor;

@end

NS_ASSUME_NONNULL_END
