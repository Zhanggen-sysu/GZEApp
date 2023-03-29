//
//  GZEMovieVIView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEBaseView.h"
@class GZEMovieImageRsp;
@class GZEYTVideoRsp;
NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieVIView : GZEBaseView

- (void)updateWithImgModel:(GZEMovieImageRsp *)imgModel videoModel:(GZEYTVideoRsp *)videoModel magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
