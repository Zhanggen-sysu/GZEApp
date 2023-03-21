//
//  GZELanguageItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/16.
//

#import "GZELanguageItem.h"

@implementation GZELanguageItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"iso_639_1": @"iso639_1",
        @"english_name": @"englishName",
        @"name": @"name"
    };
}

@end
