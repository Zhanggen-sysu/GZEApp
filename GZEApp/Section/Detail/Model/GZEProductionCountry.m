//
//  GZEProductionCountry.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEProductionCountry.h"

@implementation GZEProductionCountry

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"iso_3166_1": @"iso3166_1",
        @"name": @"name",
    };
}

@end
