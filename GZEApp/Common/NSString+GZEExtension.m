//
//  NSString+GZEExtension.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/17.
//

#import "NSString+GZEExtension.h"

@implementation NSString (GZEExtension)

// 固定宽度，自适应高度
- (CGFloat)heightWithWidth:(CGFloat)width font:(UIFont *)font
{
    return [self textSizeIn:CGSizeMake(width, CGFLOAT_MAX) font:font].height;
}

// 固定高度，自适应宽度
- (CGFloat)widthWithHeight:(CGFloat)height font:(UIFont *)font
{
    return [self textSizeIn:CGSizeMake(CGFLOAT_MAX, height) font:font].width;
}

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font
{
    return [self textSizeIn:size font:font breakMode:NSLineBreakByWordWrapping];
}

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)breakMode
{
    return [self textSizeIn:size font:afont breakMode:NSLineBreakByWordWrapping align:NSTextAlignmentLeft];
}

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)abreakMode align:(NSTextAlignment)alignment
{
    NSLineBreakMode breakMode = abreakMode;
    UIFont *font = afont ? afont : [UIFont systemFontOfSize:14];

    CGSize contentSize = CGSizeZero;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = breakMode;
    paragraphStyle.alignment = alignment;

    NSDictionary* attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    contentSize = [self boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    contentSize = CGSizeMake((int)contentSize.width + 1, (int)contentSize.height + 1);
    return contentSize;
}


@end
