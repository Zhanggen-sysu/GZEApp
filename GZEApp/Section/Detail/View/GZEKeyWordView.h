//
//  GZEKeyWordView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseView.h"
@class GZEKeywordRsp;
NS_ASSUME_NONNULL_BEGIN

@interface GZEKeyWordView : GZEBaseView

- (void)updateWithModel:(GZEKeywordRsp *)model magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
