//
//  GZESearchKWRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/9/25.
//

#import "GZEBaseReq.h"

NS_ASSUME_NONNULL_BEGIN
@class GZEGenreItem;

@interface GZESearchKWRsp : GZEBaseReq

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy)   NSArray<GZEGenreItem *> *results;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalResults;

@end

NS_ASSUME_NONNULL_END
