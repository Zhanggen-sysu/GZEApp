//
//  GZERoleItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZERoleItem.h"

@implementation GZERoleItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"credit_id": @"creditID",
        @"character": @"character",
        @"episode_count": @"episodeCount",
    };
}

@end
