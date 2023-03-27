//
//  GZEProductionCompany.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEProductionCompany.h"

@implementation GZEProductionCompany

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"logo_path": @"logoPath",
        @"name": @"name",
        @"origin_country": @"originCountry",
    };
}

@end
