//
//  GZETVCastView.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/3.
//

#import "GZEBaseView.h"
@class GZECrewCastRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZETVCastView : GZEBaseView

@property (nonatomic, copy) void (^didTapPeople)(NSInteger peopleId);

- (void)updateWithModel:(GZECrewCastRsp *)model magicColor:(nonnull UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
