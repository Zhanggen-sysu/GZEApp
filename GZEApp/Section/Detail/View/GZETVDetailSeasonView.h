//
//  GZETVDetailSeasonView.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/3.
//

#import "GZEBaseView.h"
@class GZESeasonItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZETVDetailSeasonView : GZEBaseView

- (void)updateWithModel:(NSArray<GZESeasonItem *> *)model magicColor:(nonnull UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
