//
//  GZEMovieSimilarCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEBaseCollectionViewCell.h"
@class GZEMovieListItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieSimilarCell : GZEBaseCollectionViewCell

- (void)updateWithModel:(GZEMovieListItem *)model magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
