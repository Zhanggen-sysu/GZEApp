//
//  GZECompanyListItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZECompanyListItem.h"

@implementation GZECompanyListItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"display_priority": @"displayPriority",
        @"logo_path": @"logoPath",
        @"provider_name": @"providerName",
        @"provider_id": @"providerID",
    };
}

@end
