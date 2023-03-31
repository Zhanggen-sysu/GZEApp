//
//  GZEGenreItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEGenreItem.h"

@implementation GZEGenreItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"name": @"name",
    };
}

+ (GZEGenreItem *)itemWithId:(NSInteger)identifier name:(NSString *)name
{
    GZEGenreItem *item = [[GZEGenreItem alloc] init];
    item.identifier = identifier;
    item.name = name;
    return item;
}

@end
