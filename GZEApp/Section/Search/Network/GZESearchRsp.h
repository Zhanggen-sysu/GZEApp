//
//  GZESearchRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import "GZEBaseModel.h"
@class GZESearchListItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZESearchRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy)   NSArray<GZESearchListItem *> *results;
@property (nonatomic, assign) NSInteger totalResults;
@property (nonatomic, assign) NSInteger totalPages;

@end

NS_ASSUME_NONNULL_END
