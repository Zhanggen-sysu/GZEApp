//
//  GZESeasonItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZESeasonItem.h"

@implementation GZESeasonItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"air_date": @"airDate",
        @"episode_count": @"episodeCount",
        @"id": @"identifier",
        @"name": @"name",
        @"overview": @"overview",
        @"poster_path": @"posterPath",
        @"season_number": @"seasonNumber",
    };
}

@end
