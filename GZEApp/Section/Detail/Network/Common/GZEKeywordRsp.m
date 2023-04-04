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
        @"keywords": @"keywords",
        @"results": @"results",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"keywords": [GZEGenreItem class],
        @"results": [GZEGenreItem class],
    };
}

@end
