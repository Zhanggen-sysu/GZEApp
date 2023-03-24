//
//  GZESearchReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import "GZESearchReq.h"

@implementation GZESearchReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"language": @"language",
        @"region": @"region",
        @"page": @"page",
        @"query": @"query",
        @"include_adult": @"includeAdult",
    };
}

- (NSString *)requestUrl
{
    return @"search/multi";
}

@end
