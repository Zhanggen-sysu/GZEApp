//
//  GZEDiscoverCellViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/14.
//

#import "GZEDiscoverCellViewModel.h"
#import "GZEMovieListItem.h"
#import "GZETVListItem.h"
#import "GZECommonHelper.h"
#import "GZEGlobalConfig.h"
#import "GZEGenreItem.h"

@implementation GZEDiscoverCellViewModel

+ (GZEDiscoverCellViewModel *)viewModelWithTVItem:(GZETVListItem *)item
{
    GZEDiscoverCellViewModel *viewModel = [[GZEDiscoverCellViewModel alloc] init];
    NSMutableString *title = [[NSMutableString alloc] initWithString:item.name];
    if (item.firstAirDate.length > 0) {
        [title appendString:[NSString stringWithFormat:@" (%@)", [item.firstAirDate substringToIndex:4]]];
    }
    viewModel.name = title;
    viewModel.score = [NSString stringWithFormat:@"%.1f", item.voteAverage];
    viewModel.backdropUrl = [GZECommonHelper getBackdropUrl:item.backdropPath size:GZEBackdropSize_w300];
    viewModel.posterUrl = [GZECommonHelper getPosterUrl:item.posterPath size:GZEPosterSize_w154];
    viewModel.stars = [GZECommonHelper generateRatingString:item.voteAverage starSize:15.f space:1];
    viewModel.overview = item.overview;
    viewModel.isWrap = YES;
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:[NSString stringWithFormat:@"%@ / %@", item.firstAirDate, item.originalLanguage]];
    if (item.genreIDS.count > 0) {
        [str appendString:@" / "];
        [[GZEGlobalConfig shareConfig] getGenresWithType:GZEMediaType_TV completion:^(NSDictionary<NSNumber *,NSString *> * _Nonnull genresDict) {
            NSInteger count = item.genreIDS.count;
            [item.genreIDS enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [str appendString:genresDict[obj]];
                if (idx != count - 1) {
                    [str appendString:@", "];
                }
            }];
        }];
    }
    viewModel.detail = str;
    return viewModel;
}

+ (GZEDiscoverCellViewModel *)viewModelWithMovieItem:(GZEMovieListItem *)item
{
    GZEDiscoverCellViewModel *viewModel = [[GZEDiscoverCellViewModel alloc] init];
    NSMutableString *title = [[NSMutableString alloc] initWithString:item.title];
    if (item.releaseDate.length > 0) {
        [title appendString:[NSString stringWithFormat:@" (%@)", [item.releaseDate substringToIndex:4]]];
    }
    viewModel.name = title;
    viewModel.score = [NSString stringWithFormat:@"%.1f", item.voteAverage];
    viewModel.backdropUrl = [GZECommonHelper getBackdropUrl:item.backdropPath size:GZEBackdropSize_w780];
    viewModel.posterUrl = [GZECommonHelper getPosterUrl:item.posterPath size:GZEPosterSize_w185];
    viewModel.stars = [GZECommonHelper generateRatingString:item.voteAverage starSize:15.f space:1];
    viewModel.overview = item.overview;
    viewModel.isWrap = YES;
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:[NSString stringWithFormat:@"%@ / %@", item.releaseDate, item.originalLanguage]];
    if (item.genreIDS.count > 0) {
        [str appendString:@" / "];
        [[GZEGlobalConfig shareConfig] getGenresWithType:GZEMediaType_Movie completion:^(NSDictionary<NSNumber *,NSString *> * _Nonnull genresDict) {
            NSInteger count = item.genreIDS.count;
            [item.genreIDS enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [str appendString:genresDict[obj]];
                if (idx != count - 1) {
                    [str appendString:@", "];
                }
            }];
        }];
    }
    viewModel.detail = str;
    return viewModel;
}
@end
