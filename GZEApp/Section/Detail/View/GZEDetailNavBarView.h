//
//  GZEDetailNavBarView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEBaseView.h"
@class GZEMovieDetailRsp;
@class GZETVDetailRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEDetailNavBarView : GZEBaseView

- (void)updateWithModel:(GZEMovieDetailRsp *)model;

- (void)updateWithTVModel:(GZETVDetailRsp *)model;

- (void)updateView:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
