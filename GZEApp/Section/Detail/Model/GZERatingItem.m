//
//  GZERatingItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZERatingItem.h"

@implementation GZERatingItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"descriptors": @"descriptors",
        @"iso_3166_1": @"iso3166_1",
        @"rating": @"rating",
    };
}

@end
