//
//  GZETVListRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZETVListRsp.h"
#import "GZETVListItem.h"

@implementation GZETVListRsp

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
        @"results": [GZETVListItem class],
    };
}

@end
