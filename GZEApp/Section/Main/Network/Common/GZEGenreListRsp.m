//
//  GZEGenreListRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEGenreListRsp.h"
#import "GZEGenreItem.h"

@implementation GZEGenreListRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"genres": @"genres",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"genres": [GZEGenreItem class],
    };
}

@end
