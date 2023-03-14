//
//  GZEListCollectionViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseModel.h"
@class GZEListSmallViewModel;
@class GZEMovieListItem;
@class GZETVListItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZEListCollectionViewModel : GZEBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *imgUrl;
@property (nonatomic, copy) NSArray<GZEListSmallViewModel *> *viewModels;

+ (GZEListCollectionViewModel *)viewModelWithTitle:(NSString *)title tvList:(NSArray<GZETVListItem *> *)tvList;
+ (GZEListCollectionViewModel *)viewModelWithTitle:(NSString *)title movieList:(NSArray<GZEMovieListItem *> *)movieList;

@end

NS_ASSUME_NONNULL_END
