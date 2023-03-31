//
//  GZEEpisodeToAir.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEEpisodeToAir.h"

@implementation GZEEpisodeToAir

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"name": @"name",
        @"overview": @"overview",
        @"vote_average": @"voteAverage",
        @"vote_count": @"voteCount",
        @"air_date": @"airDate",
        @"episode_number": @"episodeNumber",
        @"production_code": @"productionCode",
        @"runtime": @"runtime",
        @"season_number": @"seasonNumber",
        @"show_id": @"showID",
        @"still_path": @"stillPath",
    };
}

@end
