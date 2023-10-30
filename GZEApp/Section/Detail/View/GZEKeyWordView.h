//
//  GZEKeyWordView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseView.h"
NS_ASSUME_NONNULL_BEGIN
@class GZEGenreItem;
@class GZEKeywordRsp;

@interface GZEKeyWordView : GZEBaseView

@property (nonatomic, copy) void (^didTapKeyword)(GZEGenreItem *keyword);
- (void)updateWithModel:(GZEKeywordRsp *)model magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
