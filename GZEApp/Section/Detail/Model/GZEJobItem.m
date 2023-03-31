//
//  GZEJobItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEJobItem.h"

@implementation GZEJobItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"credit_id": @"creditID",
        @"job": @"job",
        @"episode_count": @"episodeCount",
    };
}

@end
