//
//  GZEImageBrowserScrollView.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/20.
//

#import "GZEImageBrowserScrollView.h"

@implementation GZEImageBrowserScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)reset
{
    self.zoomScale = 1;
    self.imageView.image = nil;
    self.imageView.frame = CGRectZero;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end
