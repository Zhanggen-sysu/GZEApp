//
//  GZEMovieNavBarView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEBaseView.h"
@class GZEMovieDetailRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieNavBarView : GZEBaseView

- (void)updateWithModel:(GZEMovieDetailRsp *)model;

- (void)updateView:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
