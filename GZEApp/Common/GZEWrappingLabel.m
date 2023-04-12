//
//  GZEWrappingLabel.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/22.
//

#import "GZEWrappingLabel.h"
#import <CoreText/CoreText.h>

@interface GZEWrappingLabel () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGRect wrapFrame;
@property (nonatomic, assign) CGRect expandFrame;

@end

@implementation GZEWrappingLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 一些默认值
        self.backgroundColor = [UIColor whiteColor];
        self.wrapNumberOfLine = 3;
        self.isExpand = NO;
        self.font = [UIFont systemFontOfSize:17];
        self.textColor = [UIColor blackColor];
        self.wrapText = [[NSAttributedString alloc] initWithString:@"Wrap" attributes:@{
            NSForegroundColorAttributeName:[UIColor blueColor],
            NSFontAttributeName:[UIFont systemFontOfSize:17.f],
        }];
        self.expandText = [[NSAttributedString alloc] initWithString:@"Expand" attributes:@{
            NSForegroundColorAttributeName:[UIColor blueColor],
            NSFontAttributeName:[UIFont systemFontOfSize:17.f],
        }];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
        ges.delegate = self;
        [self addGestureRecognizer:ges];
    }
    return self;
}

- (void)setIsExpand:(BOOL)isExpand
{
    if (isExpand != self.isExpand) {
        _isExpand = isExpand;
        [self invalidateIntrinsicContentSize];
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)text
{
    if (![text isEqualToString:self.text]) {
        _text = text;
        [self invalidateIntrinsicContentSize];
        [self setNeedsDisplay];
    }
}

- (void)didTapView:(UITapGestureRecognizer *)ges
{
    CGPoint point = [ges locationInView:self];
    if (CGRectContainsPoint(self.wrapFrame, point)) {
        !self.didChangeHeight ?: self.didChangeHeight(NO);
    } else if (CGRectContainsPoint(self.expandFrame, point)) {
        !self.didChangeHeight ?: self.didChangeHeight(YES);
    }
}

- (CGSize)intrinsicContentSize
{
    return [self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.text.length > 0 ? self.text : @"" attributes:@{
        NSFontAttributeName: self.font,
        NSForegroundColorAttributeName: self.textColor
    }];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    CGPoint lineOrigins[lines.count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, lines.count), lineOrigins);
    CGFloat height = 0;
    if (!self.expandText || lines.count <= 1) {
        height = lines.count * self.font.lineHeight;
    } else {
        if (!self.isExpand) {
            height = self.wrapNumberOfLine * self.font.lineHeight;
        } else {
            CTLineRef line = (__bridge CTLineRef)(lines[lines.count - 1]);
            CTLineRef truncationTokenLine = CTLineCreateWithAttributedString((CFAttributedStringRef)self.wrapText);
            double lineW = CTLineGetTypographicBounds(line, NULL, NULL, NULL);
            double tokenW = CTLineGetTypographicBounds(truncationTokenLine, NULL, NULL, NULL);
            if (lineW + tokenW > size.width) {
                height = (lines.count + 1) * self.font.lineHeight;
            } else {
                height = lines.count * self.font.lineHeight;
            }
        }
    }
    CFRelease(path);
    CFRelease(frameSetter);
    CFRelease(frame);
    return CGSizeMake(size.width, height);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // 1.创建绘制上下文（可以理解成画布）
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 2.将坐标系上下翻转（固定写法）
    // CoreText一开始是定位于桌面的排版系统，使用了传统的原点在左下角的坐标系，所以要先调整坐标系，否则绘制出来会上下颠倒
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // 3.创建绘制路径（可以理解成刷子）
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    // 4.创建文本
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{
        NSFontAttributeName: self.font,
        NSForegroundColorAttributeName: self.textColor
    }];
    // 5.创建绘制内容
    /*
    从属性字符串创建不可变的CTFramesetterRef对象。

    生成的CTFramesetterRef可用于通过CTFramesetterCreateFrame调用创建和填充CTFrame。
    */
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    /*
    使用CTFramesetterRef创建不可变CTFrameRef。

    创建一个由path参数提供的路径形状的，充满了字形的CTFrame。framesetter将继续填充frame，直到用完文本或发现不再适合的文本为止。

    framesetter
    用来创建CTFrame的CTFramesetterRef。
    stringRange
    创建framesetter的属性字符串的范围，该范围将在适合框架的行中排版。如果range的length部分设置为0，则framesetter将继续添加行，直到用完文本或空格为止。
    path
    指定frame形状的CGPath对象。该路径可能不是矩形的。
    frameAttributes
    可以在此处指定控制帧填充过程的其他属性，如果没有这样的属性，则为NULL。
    */
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    // 返回frame中的CTLine的数组
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    CGPoint lineOrigins[lines.count];
    /*
    获取CTFrame中每一行的起始坐标，结果保存在返回参数中

    将一些CGPoint结构体复制到原点缓冲区中。复制到原点缓冲区的最大行原点数是range参数的长度。
    frame
    您要从中获取线原点数组的frame。
    range
    复制的线起点范围。如果range的长度为0，则将从range的location起到最后的行原点。
    origins
    将原点复制到的缓冲区。具有至少与range.length一样多的元素。此数组中的每个CGPoint都是CTFrameGetLines返回的相对于路径边界框原点的线数组中对应线的原点，可以从CGPathGetPathBoundingBox获得该点。
    */
    CTFrameGetLineOrigins(frame, CFRangeMake(0, lines.count), lineOrigins);
    // 不设置按钮文本，不收起/展开，直接全部绘制
    if (!self.expandText || lines.count <= 1) {
        CTFrameDraw(frame, context);
    } else {
        if (!self.isExpand) {
            // 收起状态
            for (int lineIndex = 0; lineIndex < MIN(self.wrapNumberOfLine, lines.count); lineIndex ++) {
                // 获得当前行
                CTLineRef line = (__bridge CTLineRef)(lines[lineIndex]);
                // 获取该行中最初产生字形的字符范围
                CFRange range = CTLineGetStringRange(line);
                // 最后一行显示不完文字，拼接上expandText
                if (lineIndex == self.wrapNumberOfLine - 1 && range.location + range.length < attStr.length) {
                    // 创建expandText的CTLine
                    CTLineRef truncationTokenLine = CTLineCreateWithAttributedString((CFAttributedStringRef)self.expandText);
                    /*
                    计算线条的印刷范围。
                    line
                    计算其印刷范围的线。
                    ascent
                    线的上升。 如果不需要，可以将此参数设置为NULL。
                    descent
                    线的下降。 如果不需要，可以将此参数设置为NULL。
                    leading
                    该行的前导。 如果不需要，可以将此参数设置为NULL。
                    */
                    double lineW = CTLineGetTypographicBounds(line, NULL, NULL, NULL);
                    double tokenW = CTLineGetTypographicBounds(truncationTokenLine, NULL, NULL, NULL);
                    // 创建一个省略号
                    NSAttributedString *ellipses = [[NSAttributedString alloc] initWithString:@"\u2026" attributes:@{
                        NSFontAttributeName: self.font,
                        NSForegroundColorAttributeName: self.textColor,
                    }];
                    CTLineRef ellipsesTokenLine = CTLineCreateWithAttributedString((CFAttributedStringRef)ellipses);
                    /*
                    从现有行创建截断的行。
                    line
                    创建截断行的行。
                    width
                    截断开始处的宽度。如果line的宽度大于width，则该行将被截断。
                    truncationType 截断类型
                    truncationToken
                    该CTLineRef被添加到发生截断的位置，以指示该行已被截断。 通常，截断令牌是省略号（U + 2026）。 如果此参数设置为NULL，则不使用截断令牌，仅将行切断。
                    */
                    // 创建拼接了expandText的CTLine
                    // 假截断一次，才能算出真实宽度
                    CTLineRef lastLine = CTLineCreateTruncatedLine(line, lineW-0.1, kCTLineTruncationEnd, ellipsesTokenLine);
                    lineW = CTLineGetTypographicBounds(lastLine, NULL, NULL, NULL);
                    // 真正截断，并拼上省略号
                    lastLine = CTLineCreateTruncatedLine(line, lineW-tokenW, kCTLineTruncationEnd, ellipsesTokenLine);
                    CGContextSetTextPosition(context, lineOrigins[lineIndex].x, lineOrigins[lineIndex].y);
                    CTLineDraw(lastLine, context);
                    lineW = CTLineGetTypographicBounds(lastLine, NULL, NULL, NULL);
                    // 画出截断Token
                    CGContextSetTextPosition(context, lineOrigins[lineIndex].x+lineW, lineOrigins[lineIndex].y);
                    CTLineDraw(truncationTokenLine, context);
                    // y轴是反转的，所以减y轴坐标，还要再多减一行
                    self.expandFrame = CGRectMake(lineOrigins[lineIndex].x+lineW, lineIndex * self.font.lineHeight,tokenW, self.font.lineHeight);
                    CFRelease(truncationTokenLine);
                    CFRelease(ellipsesTokenLine);
                } else {
                    CGContextSetTextPosition(context, lineOrigins[lineIndex].x, lineOrigins[lineIndex].y);
                    CTLineDraw(line, context);
                }
            }
        } else {
            // 展开状态
            for (int lineIndex = 0; lineIndex < lines.count; lineIndex ++) {
                // 获得当前行
                CTLineRef line = (__bridge CTLineRef)(lines[lineIndex]);
                CGContextSetTextPosition(context, lineOrigins[lineIndex].x, lineOrigins[lineIndex].y);
                CTLineDraw(line, context);
                if (lineIndex == lines.count - 1 && self.wrapText) {
                    CTLineRef truncationTokenLine = CTLineCreateWithAttributedString((CFAttributedStringRef)self.wrapText);
                    double lineW = CTLineGetTypographicBounds(line, NULL, NULL, NULL);
                    double tokenW = CTLineGetTypographicBounds(truncationTokenLine, NULL, NULL, NULL);
                    if (lineW + tokenW > rect.size.width) {
                        // token在下一行
                        CGContextSetTextPosition(context, lineOrigins[lineIndex].x, lineOrigins[lineIndex].y - self.font.lineHeight);
                        self.wrapFrame = CGRectMake(lineOrigins[lineIndex].x, lineIndex * self.font.lineHeight, tokenW, self.font.lineHeight);
                    } else {
                        // token在行尾
                        CGContextSetTextPosition(context, lineOrigins[lineIndex].x + lineW, lineOrigins[lineIndex].y);
                        self.wrapFrame = CGRectMake(lineOrigins[lineIndex].x + lineW, (lineIndex - 1) * self.font.lineHeight, tokenW, self.font.lineHeight);
                    }
                    CTLineDraw(truncationTokenLine, context);
                    CFRelease(truncationTokenLine);
                }
            }
        }
    }
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.expandFrame, point)) {
        return YES;
    }
    if (CGRectContainsPoint(self.wrapFrame, point)) {
        return YES;
    }
    return NO;
}

@end
