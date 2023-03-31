//
//  GZEVideoListView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEBaseView.h"
@class GZEMovieListRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEVideoListView : GZEBaseView

- (instancetype)initWithTitle:(NSString *)title;

- (void)updateWithModel:(GZEMovieListRsp *)similar magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
