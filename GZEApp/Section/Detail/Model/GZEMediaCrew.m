//
//  GZEMediaCrew.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEMediaCrew.h"

@implementation GZEMediaCrew

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"adult": @"isAdult",
        @"backdrop_path": @"backdropPath",
        @"genre_ids": @"genreIDS",
        @"id": @"identifier",
        @"original_language": @"originalLanguage",
        @"original_title": @"originalTitle",
        @"overview": @"overview",
        @"popularity": @"popularity",
        @"poster_path": @"posterPath",
        @"release_date": @"releaseDate",
        @"title": @"title",
        @"video": @"video",
        @"vote_average": @"voteAverage",
        @"vote_count": @"voteCount",
        @"credit_id": @"creditID",
        @"department": @"department",
        @"job": @"job",
        @"media_type": @"mediaType",
        @"origin_country": @"originCountry",
        @"original_name": @"originalName",
        @"first_air_date": @"firstAirDate",
        @"name": @"name",
        @"episode_count": @"episodeCount",
    };
}

@end
