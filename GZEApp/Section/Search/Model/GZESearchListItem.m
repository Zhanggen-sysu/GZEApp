//
//  GZESearchListItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import "GZESearchListItem.h"
#import "GZETrendingItem.h"

@implementation GZESearchListItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"poster_path": @"posterPath",
        @"popularity": @"popularity",
        @"id": @"identifier",
        @"overview": @"overview",
        @"backdrop_path": @"backdropPath",
        @"vote_average": @"voteAverage",
        @"media_type": @"mediaType",
        @"first_air_date": @"firstAirDate",
        @"origin_country": @"originCountry",
        @"genre_ids": @"genreIDS",
        @"original_language": @"originalLanguage",
        @"vote_count": @"voteCount",
        @"name": @"name",
        @"original_name": @"originalName",
        @"adult": @"adult",
        @"release_date": @"releaseDate",
        @"original_title": @"originalTitle",
        @"title": @"title",
        @"video": @"video",
        @"profile_path": @"profilePath",
        @"known_for": @"knownFor",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"knownFor": [GZETrendingItem class],
    };
}

@end
