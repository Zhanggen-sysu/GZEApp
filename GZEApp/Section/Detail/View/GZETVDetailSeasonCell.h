//
//  GZETVDetailSeasonCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/3.
//

#import "GZEBaseCollectionViewCell.h"
@class GZESeasonItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZETVDetailSeasonCell : GZEBaseCollectionViewCell

- (void)updateWithModel:(GZESeasonItem *)model magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
