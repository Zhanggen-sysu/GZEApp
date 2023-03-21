//
//  GZEListCollectionViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEListCollectionViewModel.h"
#import "GZETVListItem.h"
#import "GZEMovieListItem.h"
#import "GZEListSmallTableViewCellModel.h"
#import "GZECommonHelper.h"

@implementation GZEListCollectionViewModel

+ (GZEListCollectionViewModel *)viewModelWithTitle:(NSString *)title tvList:(NSArray<GZETVListItem *> *)tvList
{
    GZEListCollectionViewModel *viewModel = [[GZEListCollectionViewModel alloc] init];
    viewModel.title = title;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [tvList enumerateObjectsUsingBlock:^(GZETVListItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[GZEListSmallTableViewCellModel viewModelWithTV:obj]];
        if (idx == 0) {
            viewModel.imgUrl = [GZECommonHelper getBackdropUrl:obj.backdropPath size:GZEBackdropSize_w300];
        }
        *stop = idx == 2;
    }];
    viewModel.viewModels = array;
    return viewModel;
}

+ (GZEListCollectionViewModel *)viewModelWithTitle:(NSString *)title movieList:(NSArray<GZEMovieListItem *> *)movieList
{
    GZEListCollectionViewModel *viewModel = [[GZEListCollectionViewModel alloc] init];
    viewModel.title = title;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [movieList enumerateObjectsUsingBlock:^(GZEMovieListItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[GZEListSmallTableViewCellModel viewModelWithMovie:obj]];
        if (idx == 0) {
            viewModel.imgUrl = [GZECommonHelper getBackdropUrl:obj.backdropPath size:GZEBackdropSize_w300];
        }
        *stop = idx == 2;
    }];
    viewModel.viewModels = array;
    return viewModel;
}

@end
