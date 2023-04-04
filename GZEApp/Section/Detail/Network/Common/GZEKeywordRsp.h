//
//  GZEKeywordRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseModel.h"
@class GZEGenreItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZEKeywordRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSArray<GZEGenreItem *> *keywords;
@property (nonatomic, copy)   NSArray<GZEGenreItem *> *results;

@end

NS_ASSUME_NONNULL_END
