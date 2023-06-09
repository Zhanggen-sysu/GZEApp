//
//  GZETVListItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZETVListItem.h"

@implementation GZETVListItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"adult": @"isAdult",
        @"poster_path": @"posterPath",
        @"popularity": @"popularity",
        @"id": @"identifier",
        @"backdrop_path": @"backdropPath",
        @"vote_average": @"voteAverage",
        @"overview": @"overview",
        @"first_air_date": @"firstAirDate",
        @"origin_country": @"originCountry",
        @"genre_ids": @"genreIDS",
        @"original_language": @"originalLanguage",
        @"vote_count": @"voteCount",
        @"name": @"name",
        @"original_name": @"originalName",
        @"media_type": @"mediaType",
    };
}

@end
