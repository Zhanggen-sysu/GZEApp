//
//  GZECrewCastRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
@class GZECastItem;
@class GZECrewItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZECrewCastRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSArray<GZECastItem *> *cast;
@property (nonatomic, copy)   NSArray<GZECrewItem *> *crew;

// local
@property (nonatomic, copy) NSString *director;

@end

NS_ASSUME_NONNULL_END
