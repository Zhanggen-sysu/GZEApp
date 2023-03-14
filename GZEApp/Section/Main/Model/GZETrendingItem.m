//
//  GZETrendingItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZETrendingItem.h"

@implementation GZETrendingItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"adult": @"isAdult",
        @"backdrop_path": @"backdropPath",
        @"id": @"identifier",
        @"title": @"title",
        @"original_language": @"originalLanguage",
        @"original_title": @"originalTitle",
        @"overview": @"overview",
        @"poster_path": @"posterPath",
        @"media_type": @"mediaType",
        @"genre_ids": @"genreIDS",
        @"popularity": @"popularity",
        @"release_date": @"releaseDate",
        @"video": @"video",
        @"vote_average": @"voteAverage",
        @"vote_count": @"voteCount",
        @"name": @"name",
        @"original_name": @"originalName",
        @"first_air_date": @"firstAirDate",
        @"origin_country": @"originCountry",
    };
}

@end
