//
//  GZEListSmallViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEListSmallViewModel.h"
#import "GZEMovieListItem.h"
#import "GZETVListItem.h"
#import "GZECommonHelper.h"

@implementation GZEListSmallViewModel

+ (GZEListSmallViewModel *)viewModelWithMovie:(GZEMovieListItem *)movie
{
    GZEListSmallViewModel *viewModel = [[GZEListSmallViewModel alloc] init];
    viewModel.imgUrl = [GZECommonHelper getPosterUrl:movie.posterPath size:GZEPosterSize_w92];
    viewModel.title = movie.title;
    viewModel.score = [GZECommonHelper generateRatingString:movie.voteAverage starSize:10 space:1];
    viewModel.scoreNum = [NSString stringWithFormat:@"%.1f", movie.voteAverage];
    return viewModel;
}

+ (GZEListSmallViewModel *)viewModelWithTV:(GZETVListItem *)tv
{
    GZEListSmallViewModel *viewModel = [[GZEListSmallViewModel alloc] init];
    viewModel.imgUrl = [GZECommonHelper getPosterUrl:tv.posterPath size:GZEPosterSize_w92];
    viewModel.title = tv.name;
    viewModel.score = [GZECommonHelper generateRatingString:tv.voteAverage starSize:10 space:1];
    viewModel.scoreNum = [NSString stringWithFormat:@"%.1f", tv.voteAverage];
    return viewModel;
}

@end
