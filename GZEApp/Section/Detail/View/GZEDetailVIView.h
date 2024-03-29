//
//  GZEDetailVIView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEBaseView.h"
@class GZETmdbImageRsp;
@class GZEYTVideoRsp;
NS_ASSUME_NONNULL_BEGIN

@interface GZEDetailVIView : GZEBaseView

@property (nonatomic, copy) void (^didTapImage)(NSArray *photos, NSInteger idx);
- (void)updateWithImgModel:(GZETmdbImageRsp *)imgModel videoModel:(GZEYTVideoRsp *)videoModel magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
