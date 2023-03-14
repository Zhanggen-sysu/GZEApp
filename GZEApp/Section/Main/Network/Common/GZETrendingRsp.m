//
//  GZETrendingRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZETrendingRsp.h"
#import "GZETrendingItem.h"

@implementation GZETrendingRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"page": @"page",
        @"results": @"results",
        @"total_pages": @"totalPages",
        @"total_results": @"totalResults",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"results": [GZETrendingItem class],
    };
}

@end
