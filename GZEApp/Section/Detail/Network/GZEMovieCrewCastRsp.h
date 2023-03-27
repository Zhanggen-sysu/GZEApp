//
//  GZEMovieCrewCastRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
@class GZECastItem;
@class GZECrewItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieCrewCastRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSArray<GZECastItem *> *cast;
@property (nonatomic, copy)   NSArray<GZECrewItem *> *crew;

@end

NS_ASSUME_NONNULL_END
