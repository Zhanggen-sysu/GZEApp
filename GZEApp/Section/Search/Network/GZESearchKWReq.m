//
//  GZESearchKWReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/9/25.
//

#import "GZESearchKWReq.h"

@implementation GZESearchKWReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"query": @"query",
        @"page": @"page",
    };
}

- (NSString *)requestUrl
{
    return @"search/keyword";
}

@end
