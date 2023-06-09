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
@property (nonatomic, assign) double voteAverage;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *overview;
@property (nonatomic, assign) NSInteger ID;

// 文本是否展开
@property (nonatomic, assign) BOOL isExpand;

+ (GZEDiscoverCellViewModel *)viewModelWithTVItem:(GZETVListItem *)item;
+ (GZEDiscoverCellViewModel *)viewModelWithMovieItem:(GZEMovieListItem *)item;

@end

NS_ASSUME_NONNULL_END
