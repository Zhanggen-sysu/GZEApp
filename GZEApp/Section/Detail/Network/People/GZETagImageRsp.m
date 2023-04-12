//
//  GZETagImageRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZETagImageRsp.h"
#import "GZETmdbImageItem.h"

@implementation GZETagImageRsp

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
        @"results": [GZETmdbImageItem class],
    };
}
@end
