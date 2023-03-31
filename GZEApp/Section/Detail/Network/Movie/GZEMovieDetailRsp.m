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
#import "GZECommonHelper.h"
#import "Macro.h"

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

- (NSString *)detailText
{
    if (_detailText.length > 0) {
        return _detailText;
    }
    if (self.productionCountries.count > 0 || self.releaseDate.length > 0 || self.runtime > 0 || self.revenue > 0 || self.budget > 0) {
        NSMutableString *detail = [[NSMutableString alloc] initWithString:self.productionCountries.count > 0 ? self.productionCountries.firstObject.iso3166_1 : @""];
        if (self.releaseDate.length > 0) {
            [detail appendString:detail.length > 0 ? [NSString stringWithFormat:@" · %@", self.releaseDate] : self.releaseDate];
        }
        if (self.runtime > 0) {
            NSString *runtime = [NSString stringWithFormat:@"%ldhr %ldmin", self.runtime/60, self.runtime%60];
            [detail appendString:detail.length > 0 ? [NSString stringWithFormat:@" · %@", runtime] : runtime];
        }
        if (self.budget > 0) {
            NSString *budget = [NSString stringWithFormat:@"Budget: $%@", [GZECommonHelper getNumberString:self.budget]];
            [detail appendString:detail.length > 0 ? [NSString stringWithFormat:@"\n\n%@", budget] : budget];
        }
        if (self.revenue > 0) {
            NSString *revenue = [NSString stringWithFormat:@"Revenue: $%@", [GZECommonHelper getNumberString:self.revenue]];
            if (self.budget > 0) {
                [detail appendFormat:@" | %@", revenue];
            } else if (detail.length > 0) {
                [detail appendFormat:@"\n\n%@", revenue];
            } else {
                [detail appendString:revenue];
            }
        }
        _detailText = detail;
        return detail;
    }
    return @"";
}

- (NSAttributedString *)rateText
{
    if (_rateText.length > 0) {
        return _rateText;
    }
    if (self.voteAverage > 0) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithAttributedString:[GZECommonHelper generateRatingString:self.voteAverage starSize:20 space:2]];
        [attri appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f", self.voteAverage] attributes:@{
            NSFontAttributeName: kBoldFont(16.f),
            NSForegroundColorAttributeName: RGBColor(255, 215, 0),
        }]];
        [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@" / 10" attributes:@{
            NSFontAttributeName: kFont(12.f),
            NSForegroundColorAttributeName: RGBColor(245, 245, 245),
        }]];
        _rateText = attri;
        return attri;
    }
    return [[NSAttributedString alloc] init];
}

- (NSString *)subTitleText
{
    if (_subTitleText.length > 0) {
        return _subTitleText;
    }
    if (self.originalLanguage.length > 0 && ![self.originalLanguage isEqualToString:@"en"] && self.originalTitle.length > 0) {
        NSMutableString *subTitle = [[NSMutableString alloc] initWithString:self.originalTitle];
        if (self.releaseDate.length > 0) {
            [subTitle appendString:[[NSString alloc] initWithFormat:@" (%@)", [self.releaseDate substringToIndex:4]]];
        }
        _subTitleText = subTitle;
        return subTitle;
    }
    return @"";
}

@end
