//
//  GZESearchCellViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import "GZESearchCellViewModel.h"
#import "GZETrendingItem.h"
#import "GZESearchListItem.h"
#import "GZECommonHelper.h"
#import "GZEGlobalConfig.h"

@implementation GZESearchCellViewModel

+ (GZESearchCellViewModel *)viewModelWithTrendModel:(GZETrendingItem *)model
{
    GZESearchCellViewModel *viewModel = [[GZESearchCellViewModel alloc] init];
    viewModel.stars = [GZECommonHelper generateRatingString:model.voteAverage starSize:12 space:1];
    viewModel.score = [NSString stringWithFormat:@"%.1f", model.voteAverage];
    if ([model.mediaType isEqualToString:@"movie"]) {
        viewModel.mediaType = @"Movie";
        viewModel.posterUrl = [GZECommonHelper getPosterUrl:model.posterPath size:GZEPosterSize_w92];
        viewModel.title = model.title;
        NSMutableString *str = [[NSMutableString alloc] init];
        [str appendString:[NSString stringWithFormat:@"%@ / %@", model.releaseDate, model.originalLanguage]];
        if (model.genreIDS.count > 0) {
            [str appendString:@" / "];
            [[GZEGlobalConfig shareConfig] getGenresWithType:GZEMediaType_Movie completion:^(NSDictionary<NSNumber *,NSString *> * _Nonnull genresDict) {
                NSInteger count = model.genreIDS.count;
                [model.genreIDS enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [str appendString:genresDict[obj]];
                    if (idx != count - 1) {
                        [str appendString:@", "];
                    }
                }];
            }];
        }
        viewModel.detail = str;
    } else if ([model.mediaType isEqualToString:@"tv"]) {
        viewModel.mediaType = @"TV";
        viewModel.posterUrl = [GZECommonHelper getPosterUrl:model.posterPath size:GZEPosterSize_w92];
        viewModel.title = model.name;
        NSMutableString *str = [[NSMutableString alloc] init];
        [str appendString:[NSString stringWithFormat:@"%@ / %@", model.firstAirDate, model.originalLanguage]];
        if (model.genreIDS.count > 0) {
            [str appendString:@" / "];
            [[GZEGlobalConfig shareConfig] getGenresWithType:GZEMediaType_TV completion:^(NSDictionary<NSNumber *,NSString *> * _Nonnull genresDict) {
                NSInteger count = model.genreIDS.count;
                [model.genreIDS enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [str appendString:genresDict[obj]];
                    if (idx != count - 1) {
                        [str appendString:@", "];
                    }
                }];
            }];
        }
        viewModel.detail = str;
    } else if ([model.mediaType isEqualToString:@"person"]) {
        viewModel.mediaType = @"Person";
        viewModel.posterUrl = [GZECommonHelper getProfileUrl:model.posterPath size:GZEProfileSize_w185];
        viewModel.title = model.name;
    }
    return viewModel;
}

+ (GZESearchCellViewModel *)viewModelWithSearchModel:(GZESearchListItem *)model
{
    GZESearchCellViewModel *viewModel = [[GZESearchCellViewModel alloc] init];
    viewModel.stars = [GZECommonHelper generateRatingString:model.voteAverage starSize:12 space:1];
    viewModel.score = [NSString stringWithFormat:@"%.1f", model.voteAverage];
    if ([model.mediaType isEqualToString:@"movie"]) {
        viewModel.mediaType = @"Movie";
        viewModel.posterUrl = [GZECommonHelper getPosterUrl:model.posterPath size:GZEPosterSize_w92];
        viewModel.title = model.title;
        NSMutableString *str = [[NSMutableString alloc] init];
        [str appendString:[NSString stringWithFormat:@"%@ / %@", model.releaseDate, model.originalLanguage]];
        if (model.genreIDS.count > 0) {
            [str appendString:@" / "];
            [[GZEGlobalConfig shareConfig] getGenresWithType:GZEMediaType_Movie completion:^(NSDictionary<NSNumber *,NSString *> * _Nonnull genresDict) {
                NSInteger count = model.genreIDS.count;
                [model.genreIDS enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [str appendString:genresDict[obj]];
                    if (idx != count - 1) {
                        [str appendString:@", "];
                    }
                }];
            }];
        }
        viewModel.detail = str;
    } else if ([model.mediaType isEqualToString:@"tv"]) {
        viewModel.mediaType = @"TV";
        viewModel.posterUrl = [GZECommonHelper getPosterUrl:model.posterPath size:GZEPosterSize_w92];
        viewModel.title = model.name;
        NSMutableString *str = [[NSMutableString alloc] init];
        [str appendString:[NSString stringWithFormat:@"%@ / %@", model.firstAirDate, model.originalLanguage]];
        if (model.genreIDS.count > 0) {
            [str appendString:@" / "];
            [[GZEGlobalConfig shareConfig] getGenresWithType:GZEMediaType_TV completion:^(NSDictionary<NSNumber *,NSString *> * _Nonnull genresDict) {
                NSInteger count = model.genreIDS.count;
                [model.genreIDS enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [str appendString:genresDict[obj]];
                    if (idx != count - 1) {
                        [str appendString:@", "];
                    }
                }];
            }];
        }
        viewModel.detail = str;
    } else if ([model.mediaType isEqualToString:@"person"]) {
        viewModel.mediaType = @"Person";
        viewModel.posterUrl = [GZECommonHelper getProfileUrl:model.profilePath size:GZEProfileSize_w185];
        viewModel.title = model.name;
        if (model.knownFor.count > 0) {
            GZETrendingItem *item = model.knownFor.firstObject;
            if ([item.mediaType isEqualToString:@"tv"]) {
                NSMutableString *detail = [[NSMutableString alloc] initWithString:item.name.length > 0 ? item.name : @""];
                if (item.firstAirDate.length > 0) {
                    [detail appendFormat:@" (%@)", [item.firstAirDate substringToIndex:4]];
                }
                viewModel.detail = detail;
            } else if ([item.mediaType isEqualToString:@"movie"]) {
                NSMutableString *detail = [[NSMutableString alloc] initWithString:item.title.length > 0 ? item.title : @""];
                if (item.releaseDate.length > 0) {
                    [detail appendFormat:@" (%@)", [item.releaseDate substringToIndex:4]];
                }
                viewModel.detail = detail;
            }
        }
    }
    return viewModel;
}

@end
