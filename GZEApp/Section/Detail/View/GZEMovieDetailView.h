//
//  GZEMovieDetailView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseView.h"
@class GZEMovieDetailRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieDetailView : GZEBaseView

- (void)updateWithModel:(GZEMovieDetailRsp *)rsp;

@end

NS_ASSUME_NONNULL_END
