//
//  GZEDetailListView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEBaseView.h"
@class GZEMovieListRsp;
@class GZETVListRsp;
@class GZECombinedCreditsRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEDetailListView : GZEBaseView

@property (nonatomic, copy) void (^didTapTv)(NSInteger tvId);
@property (nonatomic, copy) void (^didTapMovie)(NSInteger movieId);

- (instancetype)initWithTitle:(NSString *)title;

- (void)updateWithModel:(GZEMovieListRsp *)model magicColor:(UIColor *)magicColor;
- (void)updateWithTVModel:(GZETVListRsp *)model magicColor:(nonnull UIColor *)magicColor;
- (void)updateWithCombinedCreditModel:(GZECombinedCreditsRsp *)model;

@end

NS_ASSUME_NONNULL_END
