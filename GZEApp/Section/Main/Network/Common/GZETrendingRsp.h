//
//  GZETrendingRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseModel.h"
@class GZETrendingItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZETrendingRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy)   NSArray<GZETrendingItem *> *results;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalResults;

@end

NS_ASSUME_NONNULL_END
