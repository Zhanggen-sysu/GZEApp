//
//  GZECastSmallCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEBaseCollectionViewCell.h"
@class GZECastItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZECastSmallCell : GZEBaseCollectionViewCell

- (void)updateWithModel:(GZECastItem *)model magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
