//
//  GZEKeywordRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEKeywordRsp.h"
#import "GZEGenreItem.h"

@implementation GZEKeywordRsp

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
        @"results": [GZEGenreItem class],
    };
}

@end
