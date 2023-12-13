//
//  GZEBaseDetailViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/12/13.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GZECrewCastRsp;
@class GZETmdbReviewRsp;
@class GZETmdbImageRsp;
@class GZETmdbVideoRsp;
@class GZEYTVideoRsp;
@class GZEKeywordRsp;
@class GZEDetailListViewVM;

@interface GZEBaseDetailViewModel : GZEBaseModel

@property (nonatomic, strong) UIColor *magicColor;
@property (nonatomic, strong) GZECrewCastRsp *crewCast;
@property (nonatomic, strong) GZETmdbImageRsp *images;
@property (nonatomic, strong) GZETmdbReviewRsp *reviews;
@property (nonatomic, strong) GZETmdbVideoRsp *videos;
@property (nonatomic, strong) GZEYTVideoRsp *firstVideo;
@property (nonatomic, strong) GZEKeywordRsp *keyword;
@property (nonatomic, strong) GZEDetailListViewVM *similarVM;
@property (nonatomic, strong) GZEDetailListViewVM *recommendVM;

@property (nonatomic, strong) RACCommand *keywordCommand;

@end

NS_ASSUME_NONNULL_END
