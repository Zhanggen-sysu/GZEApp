//
//  GZEMediaCast.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEMediaCast.h"

@implementation GZEMediaCast

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
        @"character": @"character",
        @"credit_id": @"creditID",
        @"order": @"order",
        @"media_type": @"mediaType",
        @"origin_country": @"originCountry",
        @"original_name": @"originalName",
        @"first_air_date": @"firstAirDate",
        @"name": @"name",
        @"episode_count": @"episodeCount",
    };
}

@end
