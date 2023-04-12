//
//  GZECombinedCreditsRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZECombinedCreditsRsp.h"
#import "GZEMediaCrew.h"
#import "GZEMediaCast.h"

@implementation GZECombinedCreditsRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"cast": @"cast",
        @"crew": @"crew",
        @"id": @"identifier",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"cast": [GZEMediaCast class],
        @"crew": [GZEMediaCrew class],
    };
}

@end
