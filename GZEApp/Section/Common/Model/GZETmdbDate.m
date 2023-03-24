//
//  GZETmdbDate.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZETmdbDate.h"

@implementation GZETmdbDate

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"maximum": @"maximum",
        @"minimum": @"minimum",
    };
}

@end
