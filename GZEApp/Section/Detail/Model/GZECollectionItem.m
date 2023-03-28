//
//  GZECollectionItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZECollectionItem.h"

@implementation GZECollectionItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"backdrop_path": @"backdrop_path",
        @"id": @"Id",
        @"name": @"name",
        @"poster_path": @"poster_path",
    };
}

@end
