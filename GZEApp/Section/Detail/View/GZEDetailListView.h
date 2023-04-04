//
//  GZEDetailListView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEBaseView.h"
@class GZEMovieListRsp;
@class GZETVListRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEDetailListView : GZEBaseView

- (instancetype)initWithTitle:(NSString *)title;

- (void)updateWithModel:(GZEMovieListRsp *)model magicColor:(UIColor *)magicColor;
- (void)updateWithTVModel:(GZETVListRsp *)model magicColor:(nonnull UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
