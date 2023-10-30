//
//  GZESearchKWRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/9/25.
//

#import "GZESearchKWRsp.h"
#import "GZEGenreItem.h"

@implementation GZESearchKWRsp

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
        @"results": [GZEGenreItem class],
    };
}

@end
