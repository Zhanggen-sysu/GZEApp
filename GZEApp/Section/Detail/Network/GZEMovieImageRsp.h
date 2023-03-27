//
//  GZEMovieImageRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
@class GZEBackdropItem;
@class GZEPosterItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieImageRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSArray<GZEBackdropItem *> *backdrops;
@property (nonatomic, copy)   NSArray<GZEPosterItem *> *posters;

@end

NS_ASSUME_NONNULL_END
