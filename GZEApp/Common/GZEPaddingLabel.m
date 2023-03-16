//
//  GZEPaddingLabel.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/16.
//

#import "GZEPaddingLabel.h"

@implementation GZEPaddingLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets) limitedToNumberOfLines:numberOfLines];
    rect.origin.x -= self.edgeInsets.left;
    rect.origin.y -= self.edgeInsets.top;
    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return rect;
}

@end
