//
//  GZEDetailListCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEBaseCollectionViewCell.h"
@class GZEMovieListItem;
@class GZETVListItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZEDetailListCell : GZEBaseCollectionViewCell

- (void)updateWithModel:(GZEMovieListItem *)model magicColor:(UIColor *)magicColor;

- (void)updateWithTVModel:(GZETVListItem *)model magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
