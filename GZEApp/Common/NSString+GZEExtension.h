//
//  NSString+GZEExtension.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (GZEExtension)

// 固定宽度，自适应高度
- (CGFloat)heightWithWidth:(CGFloat)width font:(UIFont *)font;
// 固定高度，自适应宽度
- (CGFloat)widthWithHeight:(CGFloat)height font:(UIFont *)font;
// 固定宽度，计算总行数
- (NSInteger)numberOflines:(CGFloat)width font:(UIFont *)font;

// TUIKit
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font;
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)breakMode;
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)abreakMode align:(NSTextAlignment)alignment;

@end

NS_ASSUME_NONNULL_END
