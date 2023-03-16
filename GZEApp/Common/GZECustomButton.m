//
//  GZECustomButton.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/15.
//

#import "GZECustomButton.h"

@implementation GZECustomButton

- (void)setImagePosition:(GZEBtnImgPosition)imagePosition
                 spacing:(CGFloat)spacing
            contentAlign:(GZEBtnContentAlign)contentAlign
           contentOffset:(CGFloat)contentOffset
               imageSize:(CGSize)imageSize
               titleSize:(CGSize)titleSize;
{
    self.imagePosition = imagePosition;
    self.spacing = spacing;
    self.imageSize = imageSize;
    self.titleSize = titleSize;
    self.contentAlign = contentAlign;
    self.contentOffset = contentOffset;
    // 重绘一下
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    // 此时按钮有了宽高
    [super layoutSubviews];
    switch (self.imagePosition) {
        case GZEBtnImgPosition_Left:
            [self layoutSubviewsForImageLeft];
            break;
        case GZEBtnImgPosition_Right:
            [self layoutSubviewsForImageRight];
            break;
        case GZEBtnImgPosition_Top:
            [self layoutSubviewsForImageTop];
            break;
        case GZEBtnImgPosition_Bottom:
            [self layoutSubviewsForImageBottom];
            break;
        default:
            break;
    }
    
}

// 左图右文
- (void)layoutSubviewsForImageLeft
{
    CGRect imageRect = self.imageView.frame;
    CGRect titleRect = self.titleLabel.frame;
    imageRect.size = (self.imageSize.width > 0 && self.imageSize.height > 0)? CGSizeMake(self.imageSize.width, self.imageSize.height): imageRect.size;
    titleRect.size = (self.titleSize.width > 0 && self.titleSize.height > 0)? CGSizeMake(self.titleSize.width, self.titleSize.height): titleRect.size;
    CGFloat imageX = 0;
    CGFloat titleX = 0;
    CGFloat imageY = 0;
    CGFloat titleY = 0;
    switch (self.contentAlign) {
        case GZEBtnContentAlign_Left:
            imageX = self.contentOffset;
            titleX = imageX + imageRect.size.width + self.spacing;
            imageY = (self.frame.size.height - imageRect.size.height) / 2;
            titleY = (self.frame.size.height - titleRect.size.height) / 2;
            break;
        case GZEBtnContentAlign_Right:
            titleX = self.frame.size.width - self.contentOffset - titleRect.size.width;
            imageX = titleX - self.spacing - imageRect.size.width;
            imageY = (self.frame.size.height - imageRect.size.height) / 2;
            titleY = (self.frame.size.height - titleRect.size.height) / 2;
            break;
        case GZEBtnContentAlign_Top:
            imageX = (self.frame.size.width - titleRect.size.width - self.spacing - imageRect.size.width) / 2;
            titleX = imageX + imageRect.size.width + self.spacing;
            if (imageRect.size.height > titleRect.size.height) {
                imageY = self.contentOffset;
                titleY = imageY + imageRect.size.height / 2 - titleRect.size.height / 2;
            } else {
                titleY = self.contentOffset;
                imageY = titleY + titleRect.size.height / 2 - imageRect.size.height / 2;
            }
            break;
        case GZEBtnContentAlign_Bottom:
            imageX = (self.frame.size.width - titleRect.size.width - self.spacing - imageRect.size.width) / 2;
            titleX = imageX + imageRect.size.width + self.spacing;
            if (imageRect.size.height > titleRect.size.height) {
                imageY = self.frame.size.height - self.contentOffset - imageRect.size.height;
                titleY = imageY + imageRect.size.height / 2 - titleRect.size.height / 2;
            } else {
                titleY = self.frame.size.height - self.contentOffset - titleRect.size.height;
                imageY = titleY + titleRect.size.height / 2 - imageRect.size.height / 2;
            }
            break;
        case GZEBtnContentAlign_Center:
            imageX = (self.frame.size.width - titleRect.size.width - self.spacing - imageRect.size.width) / 2;
            titleX = imageX + imageRect.size.width + self.spacing;
            imageY = (self.frame.size.height - imageRect.size.height) / 2;
            titleY = (self.frame.size.height - titleRect.size.height) / 2;
            break;
        default:
            break;
    }
    imageRect.origin = CGPointMake(imageX, imageY);
    titleRect.origin = CGPointMake(titleX, titleY);
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
}

// 左文右图
- (void)layoutSubviewsForImageRight
{
    CGRect imageRect = self.imageView.frame;
    CGRect titleRect = self.titleLabel.frame;
    imageRect.size = (self.imageSize.width > 0 && self.imageSize.height > 0)? CGSizeMake(self.imageSize.width, self.imageSize.height): imageRect.size;
    titleRect.size = (self.titleSize.width > 0 && self.titleSize.height > 0)? CGSizeMake(self.titleSize.width, self.titleSize.height): titleRect.size;
    CGFloat imageX = 0;
    CGFloat titleX = 0;
    CGFloat imageY = 0;
    CGFloat titleY = 0;
    switch (self.contentAlign) {
        case GZEBtnContentAlign_Left:
            titleX = self.contentOffset;
            imageX = titleX + titleRect.size.width + self.spacing;
            imageY = (self.frame.size.height - imageRect.size.height) / 2;
            titleY = (self.frame.size.height - titleRect.size.height) / 2;
            break;
        case GZEBtnContentAlign_Right:
            imageX = self.frame.size.width - self.contentOffset - imageRect.size.width;
            titleX = imageX - self.spacing - titleRect.size.width;
            imageY = (self.frame.size.height - imageRect.size.height) / 2;
            titleY = (self.frame.size.height - titleRect.size.height) / 2;
            break;
        case GZEBtnContentAlign_Top:
            titleX = (self.frame.size.width - titleRect.size.width - self.spacing - imageRect.size.width) / 2;
            imageX = titleX + titleRect.size.width + self.spacing;
            if (imageRect.size.height > titleRect.size.height) {
                imageY = self.contentOffset;
                titleY = imageY + imageRect.size.height / 2 - titleRect.size.height / 2;
            } else {
                titleY = self.contentOffset;
                imageY = titleY + titleRect.size.height / 2 - imageRect.size.height / 2;
            }
            break;
        case GZEBtnContentAlign_Bottom:
            titleX = (self.frame.size.width - titleRect.size.width - self.spacing - imageRect.size.width) / 2;
            imageX = titleX + titleRect.size.width + self.spacing;
            if (imageRect.size.height > titleRect.size.height) {
                imageY = self.frame.size.height - self.contentOffset - imageRect.size.height;
                titleY = imageY + imageRect.size.height / 2 - titleRect.size.height / 2;
            } else {
                titleY = self.frame.size.height - self.contentOffset - titleRect.size.height;
                imageY = titleY + titleRect.size.height / 2 - imageRect.size.height / 2;
            }
            break;
        case GZEBtnContentAlign_Center:
            titleX = (self.frame.size.width - titleRect.size.width - self.spacing - imageRect.size.width) / 2;
            imageX = titleX + titleRect.size.width + self.spacing;
            imageY = (self.frame.size.height - imageRect.size.height) / 2;
            titleY = (self.frame.size.height - titleRect.size.height) / 2;
            break;
        default:
            break;
    }
    imageRect.origin = CGPointMake(imageX, imageY);
    titleRect.origin = CGPointMake(titleX, titleY);
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
}

// 上图下文
- (void)layoutSubviewsForImageTop
{
    CGRect imageRect = self.imageView.frame;
    CGRect titleRect = self.titleLabel.frame;
    imageRect.size = (self.imageSize.width > 0 && self.imageSize.height > 0)? CGSizeMake(self.imageSize.width, self.imageSize.height): imageRect.size;
    titleRect.size = (self.titleSize.width > 0 && self.titleSize.height > 0)? CGSizeMake(self.titleSize.width, self.titleSize.height): titleRect.size;
    CGFloat imageX = 0;
    CGFloat titleX = 0;
    CGFloat imageY = 0;
    CGFloat titleY = 0;
    switch (self.contentAlign) {
        case GZEBtnContentAlign_Left:
            imageY = (self.frame.size.height - titleRect.size.height - self.spacing - imageRect.size.height) / 2;
            titleY = imageY + imageRect.size.height + self.spacing;
            if (imageRect.size.width > titleRect.size.width) {
                imageX = self.contentOffset;
                titleX = imageX + imageRect.size.width / 2 - titleRect.size.width / 2;
            } else {
                titleX = self.contentOffset;
                imageX = titleX + titleRect.size.width / 2 - imageRect.size.width / 2;
            }
            break;
        case GZEBtnContentAlign_Right:
            imageY = (self.frame.size.height - titleRect.size.height - self.spacing - imageRect.size.height) / 2;
            titleY = imageY + imageRect.size.height + self.spacing;
            if (imageRect.size.width > titleRect.size.width) {
                imageX = self.frame.size.width - self.contentOffset - imageRect.size.width;
                titleX = imageX + imageRect.size.width / 2 - titleRect.size.width / 2;
            } else {
                titleX = self.frame.size.width - self.contentOffset - titleRect.size.width;
                imageX = titleX + titleRect.size.width / 2 - imageRect.size.width / 2;
            }
            break;
        case GZEBtnContentAlign_Top:
            imageY = self.contentOffset;
            titleY = imageY + imageRect.size.height + self.spacing;
            imageX = (self.frame.size.width - imageRect.size.width) / 2;
            titleX = (self.frame.size.width - titleRect.size.width) / 2;
            break;
        case GZEBtnContentAlign_Bottom:
            titleY = self.frame.size.height - self.contentOffset - titleRect.size.height;
            imageY = titleY - self.spacing - imageRect.size.height;
            imageX = (self.frame.size.width - imageRect.size.width) / 2;
            titleX = (self.frame.size.width - titleRect.size.width) / 2;
            break;
        case GZEBtnContentAlign_Center:
            imageY = (self.frame.size.height - titleRect.size.height - self.spacing - imageRect.size.height) / 2;
            titleY = imageY + imageRect.size.height + self.spacing;
            imageX = (self.frame.size.width - imageRect.size.width) / 2;
            titleX = (self.frame.size.width - titleRect.size.width) / 2;
            break;
        default:
            break;
    }
    imageRect.origin = CGPointMake(imageX, imageY);
    titleRect.origin = CGPointMake(titleX, titleY);
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
}

// 上文下图
- (void)layoutSubviewsForImageBottom
{
    CGRect imageRect = self.imageView.frame;
    CGRect titleRect = self.titleLabel.frame;
    imageRect.size = (self.imageSize.width > 0 && self.imageSize.height > 0)? CGSizeMake(self.imageSize.width, self.imageSize.height): imageRect.size;
    titleRect.size = (self.titleSize.width > 0 && self.titleSize.height > 0)? CGSizeMake(self.titleSize.width, self.titleSize.height): titleRect.size;
    CGFloat imageX = 0;
    CGFloat titleX = 0;
    CGFloat imageY = 0;
    CGFloat titleY = 0;
    switch (self.contentAlign) {
        case GZEBtnContentAlign_Left:
            titleY = (self.frame.size.height - titleRect.size.height - self.spacing - imageRect.size.height) / 2;
            imageY = titleY + titleRect.size.height + self.spacing;
            if (imageRect.size.width > titleRect.size.width) {
                imageX = self.contentOffset;
                titleX = imageX + imageRect.size.width / 2 - titleRect.size.width / 2;
            } else {
                titleX = self.contentOffset;
                imageX = titleX + titleRect.size.width / 2 - imageRect.size.width / 2;
            }
            break;
        case GZEBtnContentAlign_Right:
            titleY = (self.frame.size.height - titleRect.size.height - self.spacing - imageRect.size.height) / 2;
            imageY = titleY + titleRect.size.height + self.spacing;
            if (imageRect.size.width > titleRect.size.width) {
                imageX = self.frame.size.width - self.contentOffset - imageRect.size.width;
                titleX = imageX + imageRect.size.width / 2 - titleRect.size.width / 2;
            } else {
                titleX = self.frame.size.width - self.contentOffset - titleRect.size.width;
                imageX = titleX + titleRect.size.width / 2 - imageRect.size.width / 2;
            }
            break;
        case GZEBtnContentAlign_Top:
            titleY = self.contentOffset;
            imageY = titleY + titleRect.size.height + self.spacing;
            imageX = (self.frame.size.width - imageRect.size.width) / 2;
            titleX = (self.frame.size.width - titleRect.size.width) / 2;
            break;
        case GZEBtnContentAlign_Bottom:
            imageY = self.frame.size.height - self.contentOffset - imageRect.size.height;
            titleY = imageY - self.spacing - titleRect.size.height;
            imageX = (self.frame.size.width - imageRect.size.width) / 2;
            titleX = (self.frame.size.width - titleRect.size.width) / 2;
            break;
        case GZEBtnContentAlign_Center:
            titleY = (self.frame.size.height - titleRect.size.height - self.spacing - imageRect.size.height) / 2;
            imageY = titleY + titleRect.size.height + self.spacing;
            imageX = (self.frame.size.width - imageRect.size.width) / 2;
            titleX = (self.frame.size.width - titleRect.size.width) / 2;
            break;
        default:
            break;
    }
    imageRect.origin = CGPointMake(imageX, imageY);
    titleRect.origin = CGPointMake(titleX, titleY);
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
}

@end
