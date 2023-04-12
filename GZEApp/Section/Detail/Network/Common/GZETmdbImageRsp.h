//
//  GZETmdbImageRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
@class GZETmdbImageItem;
@class GZETmdbImageItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZETmdbImageRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSArray<GZETmdbImageItem *> *backdrops;
@property (nonatomic, copy)   NSArray<GZETmdbImageItem *> *posters;
// TV
@property (nonatomic, copy)   NSArray<GZETmdbImageItem *> *logos;
// people
@property (nonatomic, copy)   NSArray<GZETmdbImageItem *> *profiles;

@end

NS_ASSUME_NONNULL_END
