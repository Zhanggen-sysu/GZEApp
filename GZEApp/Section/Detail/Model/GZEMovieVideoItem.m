//
//  GZEMovieVideoItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEMovieVideoItem.h"

@implementation GZEMovieVideoItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"iso_639_1": @"iso639_1",
        @"iso_3166_1": @"iso3166_1",
        @"name": @"name",
        @"key": @"key",
        @"site": @"site",
        @"size": @"size",
        @"type": @"type",
        @"official": @"isOfficial",
        @"published_at": @"publishedAt",
        @"id": @"identifier",
    };
}

@end
