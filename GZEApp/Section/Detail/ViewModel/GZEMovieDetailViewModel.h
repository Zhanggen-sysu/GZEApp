//
//  GZEMovieDetailViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
#import <UIKit/UIKit.h>
@class GZECrewCastRsp;
@class GZETmdbReviewRsp;
@class GZETmdbImageRsp;
@class GZEMovieDetailRsp;
@class GZEMovieListRsp;
@class GZETmdbVideoRsp;
@class GZEYTVideoRsp;
@class GZEKeywordRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieDetailViewModel : GZEBaseModel

@property (nonatomic, strong) GZECrewCastRsp *crewCast;
@property (nonatomic, strong) GZEMovieDetailRsp *commonInfo;
@property (nonatomic, strong) GZETmdbImageRsp *images;
@property (nonatomic, strong) GZETmdbReviewRsp *reviews;
@property (nonatomic, strong) GZEMovieListRsp *similar;
@property (nonatomic, strong) GZEMovieListRsp *recommend;
@property (nonatomic, strong) GZETmdbVideoRsp *videos;
@property (nonatomic, strong) GZEYTVideoRsp *firstVideo;
@property (nonatomic, strong) GZEKeywordRsp *keyword;
@property (nonatomic, strong) UIColor *magicColor;

@end

NS_ASSUME_NONNULL_END
