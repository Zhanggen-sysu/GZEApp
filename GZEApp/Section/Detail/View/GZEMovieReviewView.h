//
//  GZEMovieReviewView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/30.
//

#import "GZEBaseView.h"
@class GZEMovieReviewRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieReviewView : GZEBaseView

- (void)updateWithModel:(GZEMovieReviewRsp *)model magicColor:(nonnull UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
