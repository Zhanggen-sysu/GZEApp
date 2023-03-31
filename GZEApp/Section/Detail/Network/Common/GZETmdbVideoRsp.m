//
//  GZETmdbVideoRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZETmdbVideoRsp.h"
#import "GZETmdbVideoItem.h"

@implementation GZETmdbVideoRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"results": @"results",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"results": [GZETmdbVideoItem class],
    };
}
@end
