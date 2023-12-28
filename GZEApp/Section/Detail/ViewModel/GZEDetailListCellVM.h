//
//  GZEDetailListCellVM.h
//  GZEApp
//
//  Created by GenZhang on 2023/12/8.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GZEMovieListItem;
@class GZETVListItem;

@interface GZEDetailListCellVM : GZEBaseModel
@property (nonatomic, strong, readonly) UIColor *magicColor;
@property (nonatomic, strong, readonly) NSURL *posterUrl;
@property (nonatomic, copy, readonly) NSAttributedString *ratingString;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSInteger identifier;

- (instancetype)initWithMovieListItem:(GZEMovieListItem *)movieItem magicColor:(UIColor *)magicColor;
- (instancetype)initWithTVListItem:(GZETVListItem *)tvItem magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
