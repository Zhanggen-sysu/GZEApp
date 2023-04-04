//
//  GZETVDetailRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZETVDetailRsp.h"
#import "GZECreateByItem.h"
#import "GZEGenreItem.h"
#import "GZETmdbNetwork.h"
#import "GZEProductionCompany.h"
#import "GZEProductionCountry.h"
#import "GZESeasonItem.h"
#import "GZELanguageItem.h"
#import "GZETVRatingRsp.h"
#import "GZERatingItem.h"

@implementation GZETVDetailRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"adult": @"isAdult",
        @"backdrop_path": @"backdropPath",
        @"created_by": @"createdBy",
        @"episode_run_time": @"episodeRunTime",
        @"first_air_date": @"firstAirDate",
        @"genres": @"genres",
        @"homepage": @"homepage",
        @"id": @"identifier",
        @"in_production": @"isInProduction",
        @"languages": @"languages",
        @"last_air_date": @"lastAirDate",
        @"last_episode_to_air": @"lastEpisodeToAir",
        @"name": @"name",
        @"next_episode_to_air": @"nextEpisodeToAir",
        @"networks": @"networks",
        @"number_of_episodes": @"numberOfEpisodes",
        @"number_of_seasons": @"numberOfSeasons",
        @"origin_country": @"originCountry",
        @"original_language": @"originalLanguage",
        @"original_name": @"originalName",
        @"overview": @"overview",
        @"popularity": @"popularity",
        @"poster_path": @"posterPath",
        @"production_companies": @"productionCompanies",
        @"production_countries": @"productionCountries",
        @"seasons": @"seasons",
        @"spoken_languages": @"spokenLanguages",
        @"status": @"status",
        @"tagline": @"tagline",
        @"type": @"type",
        @"vote_average": @"voteAverage",
        @"vote_count": @"voteCount",
        @"aggregate_credits": @"aggregateCredits",
        @"content_ratings": @"contentRatings",
        @"images": @"images",
        @"keywords": @"keywords",
        @"recommendations": @"recommendations",
        @"reviews": @"reviews",
        @"similar": @"similar",
        @"videos": @"videos",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"createdBy": [GZECreateByItem class],
        @"genres": [GZEGenreItem class],
        @"networks": [GZETmdbNetwork class],
        @"productionCompanies": [GZEProductionCompany class],
        @"productionCountries": [GZEProductionCountry class],
        @"seasons": [GZESeasonItem class],
        @"spokenLanguages": [GZELanguageItem class],
    };
}

- (NSString *)detailText
{
    if (_detailText.length > 0) {
        return _detailText;
    }
    NSMutableString *detail = [[NSMutableString alloc] init];
    if (self.originalLanguage.length > 0) {
        [detail appendString:self.originalLanguage];
    }
    if (self.firstAirDate.length > 0) {
        [detail appendString:detail.length > 0 ? [NSString stringWithFormat:@" · %@", self.firstAirDate] : self.firstAirDate];
    }
    [self.contentRatings.results enumerateObjectsUsingBlock:^(GZERatingItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.iso3166_1 isEqualToString:@"US"]) {
            [detail appendString:detail.length > 0 ? [NSString stringWithFormat:@" · %@", obj.rating] : obj.rating];
            *stop = YES;
        }
    }];
    _detailText = detail;
    return detail;
}

- (NSString *)countryText
{
    if (_countryText.length > 0) {
        return _countryText;
    }
    if (self.productionCountries.count > 0) {
        NSMutableString *text = [[NSMutableString alloc] init];
        [self.productionCountries enumerateObjectsUsingBlock:^(GZEProductionCountry * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [text appendString:obj.iso3166_1];
            if (idx != self.productionCountries.count - 1) {
                [text appendString:@", "];
            }
        }];
        _countryText = text;
        return text;
    }
    return @"";
}

- (NSString *)directorText
{
    if (_directorText.length > 0) {
        return _directorText;
    }
    if (self.createdBy.count > 0) {
        NSMutableString *text = [[NSMutableString alloc] init];
        [self.createdBy enumerateObjectsUsingBlock:^(GZECreateByItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [text appendString:obj.name];
            if (idx != self.createdBy.count - 1) {
                [text appendString:@", "];
            }
        }];
        _directorText = text;
        return text;
    }
    return @"";
}

- (NSString *)subTitleText
{
    if (_subTitleText.length > 0) {
        return _subTitleText;
    }
    if (self.originalLanguage.length > 0 && ![self.originalLanguage isEqualToString:@"en"] && self.originalName.length > 0) {
        NSMutableString *subTitle = [[NSMutableString alloc] initWithString:self.originalName];
        if (self.firstAirDate.length > 0) {
            [subTitle appendString:[[NSString alloc] initWithFormat:@" (%@)", [self.firstAirDate substringToIndex:4]]];
        }
        _subTitleText = subTitle;
        return subTitle;
    }
    return @"";
}

- (NSString *)companyText
{
    if (_companyText.length > 0) {
        return _companyText;
    }
    if (self.productionCompanies.count > 0) {
        NSMutableString *text = [[NSMutableString alloc] init];
        [self.productionCompanies enumerateObjectsUsingBlock:^(GZEProductionCompany * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [text appendString:obj.name];
            if (obj.originCountry.length > 0) {
                [text appendString:[NSString stringWithFormat:@"(%@)", obj.originCountry]];
            }
            if (idx != self.productionCompanies.count - 1) {
                [text appendString:@", "];
            }
        }];
        _companyText = text;
        return text;
    }
    return @"";
}

- (NSString *)networkText
{
    if (_networkText.length > 0) {
        return _networkText;
    }
    if (self.networks.count > 0) {
        NSMutableString *text = [[NSMutableString alloc] init];
        [self.networks enumerateObjectsUsingBlock:^(GZETmdbNetwork * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [text appendString:obj.name];
            if (obj.originCountry.length > 0) {
                [text appendString:[NSString stringWithFormat:@"(%@)", obj.originCountry]];
            }
            if (idx != self.networks.count - 1) {
                [text appendString:@", "];
            }
        }];
        _networkText = text;
        return text;
    }
    return @"";
}

@end
