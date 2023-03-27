//
//  GZEMovieImageRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEMovieImageRsp.h"
#import "GZEBackdropItem.h"
#import "GZEPosterItem.h"

@implementation GZEMovieImageRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"backdrops": @"backdrops",
        @"posters": @"posters",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"backdrops": [GZEBackdropItem class],
        @"posters": [GZEPosterItem class],
    };
}

@end
