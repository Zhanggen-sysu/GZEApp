//
//  GZECrewCastRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZECrewCastRsp.h"
#import "GZECastItem.h"
#import "GZECrewItem.h"

@implementation GZECrewCastRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"cast": @"cast",
        @"crew": @"crew",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"cast": [GZECastItem class],
        @"crew": [GZECrewItem class],
    };
}

@end
