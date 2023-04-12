//
//  GZEMovieCastView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEBaseView.h"
@class GZECrewCastRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieCastView : GZEBaseView

@property (nonatomic, copy) void (^didTapPeople)(NSInteger peopleId);

- (void)updateWithModel:(GZECrewCastRsp *)model magicColor:(nonnull UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
