//
//  UIImage+magicColor.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (magicColor)

// 计算魔法色，代码来源：https://www.jianshu.com/p/7ff195f2d36c
- (UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
