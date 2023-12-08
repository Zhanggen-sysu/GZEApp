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


@class GZEDetailListViewVM;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieDetailViewModel : GZEBaseModel

@property (nonatomic, strong, readonly) GZEMovieDetailRsp *commonInfo;
@property (nonatomic, strong, readonly) GZECrewCastRsp *crewCast;
@property (nonatomic, strong, readonly) GZETmdbImageRsp *images;
@property (nonatomic, strong, readonly) GZETmdbReviewRsp *reviews;
@property (nonatomic, strong, readonly) GZEMovieListRsp *similar;
@property (nonatomic, strong, readonly) GZEMovieListRsp *recommend;
@property (nonatomic, strong, readonly) GZETmdbVideoRsp *videos;
@property (nonatomic, strong, readonly) GZEYTVideoRsp *firstVideo;
@property (nonatomic, strong, readonly) GZEKeywordRsp *keyword;
@property (nonatomic, strong, readonly) UIColor *magicColor;
@property (nonatomic, strong, readonly) GZEDetailListViewVM *similarVM;
@property (nonatomic, strong, readonly) GZEDetailListViewVM *recommendVM;

@property (nonatomic, strong, readonly) RACCommand *reqCommand;

- (instancetype)initWithMovieId:(NSInteger)movieId;

@end

NS_ASSUME_NONNULL_END
