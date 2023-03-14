//
//  GZEMovieListRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZEMovieListRsp.h"
#import "GZEMovieListItem.h"

@implementation GZEMovieListRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"page": @"page",
        @"results": @"results",
        @"dates": @"dates",
        @"total_pages": @"totalPages",
        @"total_results": @"totalResults",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"results": [GZEMovieListItem class],
    };
}

@end
