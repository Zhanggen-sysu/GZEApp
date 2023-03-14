//
//  GZETVListRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseModel.h"
@class GZETVListItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZETVListRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy)   NSArray<GZETVListItem *> *results;
@property (nonatomic, assign) NSInteger totalResults;
@property (nonatomic, assign) NSInteger totalPages;

@end

NS_ASSUME_NONNULL_END
