//
//  GZETVRatingRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseModel.h"
@class GZERatingItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZETVRatingRsp : GZEBaseModel

@property (nonatomic, copy)   NSArray<GZERatingItem *> *results;
@property (nonatomic, assign) NSInteger identifier;

@end

NS_ASSUME_NONNULL_END
