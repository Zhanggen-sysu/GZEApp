//
//  GZETmdbReviewRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
@class GZEReviewItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZETmdbReviewRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy)   NSArray<GZEReviewItem *> *results;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalResults;

@end

NS_ASSUME_NONNULL_END
