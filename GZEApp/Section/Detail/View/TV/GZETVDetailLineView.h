//
//  GZETVDetailLineView.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/3.
//

#import "GZEBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZETVDetailLineView : GZEBaseView

- (instancetype)initWithTitle:(NSString *)title;
- (void)updateWithDetail:(NSString *)detail;
- (void)updateWithLinkDetail:(NSString *)linkDetail;

@end

NS_ASSUME_NONNULL_END
