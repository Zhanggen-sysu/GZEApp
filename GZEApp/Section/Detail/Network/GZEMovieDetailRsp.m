//
//  GZEMovieDetailRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEMovieDetailRsp.h"
#import "GZEGenreItem.h"
#import "GZEProductionCompany.h"
#import "GZEProductionCountry.h"
#import "GZELanguageItem.h"
#import "GZECollectionItem.h"

@implementation GZEMovieDetailRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"adult": @"isAdult",
        @"backdrop_path": @"backdropPath",
        @"belongs_to_collection": @"belongsToCollection",
        @"budget": @"budget",
        @"genres": @"genres",
        @"homepage": @"homepage",
        @"id": @"identifier",
        @"imdb_id": @"imdbID",
        @"original_language": @"originalLanguage",
        @"original_title": @"originalTitle",
        @"overview": @"overview",
        @"popularity": @"popularity",
        @"poster_path": @"posterPath",
        @"production_companies": @"productionCompanies",
        @"production_countries": @"productionCountries",
        @"release_date": @"releaseDate",
        @"revenue": @"revenue",
        @"runtime": @"runtime",
        @"spoken_languages": @"spokenLanguages",
        @"status": @"status",
        @"tagline": @"tagline",
        @"title": @"title",
        @"video": @"isVideo",
        @"vote_average": @"voteAverage",
        @"vote_count": @"voteCount",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"genres": [GZEGenreItem class],
        @"productionCompanies": [GZEProductionCompany class],
        @"productionCountries": [GZEProductionCountry class],
        @"spokenLanguages": [GZELanguageItem class],
    };
}

@end
