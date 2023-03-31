//
//  GZETVRatingRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZETVRatingRsp.h"
#import "GZERatingItem.h"

@implementation GZETVRatingRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"results": @"results",
        @"id": @"identifier",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"results": [GZERatingItem class],
    };
}

@end
