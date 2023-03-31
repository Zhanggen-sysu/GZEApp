//
//  GZETmdbImageRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZETmdbImageRsp.h"
#import "GZETmdbImageItem.h"
#import "GZETmdbImageItem.h"

@implementation GZETmdbImageRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"backdrops": @"backdrops",
        @"posters": @"posters",
        @"logos": @"logos",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"backdrops": [GZETmdbImageItem class],
        @"posters": [GZETmdbImageItem class],
        @"logos": [GZETmdbImageItem class],
    };
}

@end
