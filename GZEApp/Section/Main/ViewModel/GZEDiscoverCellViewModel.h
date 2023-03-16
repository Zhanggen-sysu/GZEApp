//
//  GZEDiscoverCellViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/14.
//

#import "GZEBaseModel.h"

@class GZEMovieListItem;
@class GZETVListItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZEDiscoverCellViewModel : GZEBaseModel

@property (nonatomic, strong) NSURL *posterUrl;
@property (nonatomic, strong) NSURL *backdropUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSAttributedString *stars;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *overview;

+ (GZEDiscoverCellViewModel *)viewModelWithTVItem:(GZETVListItem *)item;
+ (GZEDiscoverCellViewModel *)viewModelWithMovieItem:(GZEMovieListItem *)item;

@end

NS_ASSUME_NONNULL_END
