//
//  GZETagImageRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEBaseModel.h"
@class GZETmdbImageItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZETagImageRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy)   NSArray<GZETmdbImageItem *> *results;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalResults;

@end

NS_ASSUME_NONNULL_END
