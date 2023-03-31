//
//  GZETmdbVideoRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEBaseModel.h"
@class GZETmdbVideoItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZETmdbVideoRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSArray<GZETmdbVideoItem *> *results;

@end

NS_ASSUME_NONNULL_END
