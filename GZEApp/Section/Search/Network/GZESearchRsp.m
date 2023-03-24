//
//  GZESearchRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import "GZESearchRsp.h"
#import "GZESearchListItem.h"

@implementation GZESearchRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"page": @"page",
        @"results": @"results",
        @"total_results": @"totalResults",
        @"total_pages": @"totalPages",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"results": [GZESearchListItem class],
    };
}

@end
