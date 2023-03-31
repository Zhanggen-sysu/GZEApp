//
//  GZETVDetailView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseView.h"
@class GZETVDetailRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZETVDetailView : GZEBaseView

- (void)updateWithModel:(GZETVDetailRsp *)model magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
