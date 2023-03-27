//
//  GZEMovieReviewRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEMovieReviewRsp.h"
#import "GZEReviewItem.h"

@implementation GZEMovieReviewRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"page": @"page",
        @"results": @"results",
        @"total_pages": @"totalPages",
        @"total_results": @"totalResults",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"results": [GZEReviewItem class],
    };
}

@end
