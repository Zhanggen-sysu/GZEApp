//
//  GZEImageBrowserCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/13.
//

#import "GZEImageBrowserCell.h"
#import "GZEImageBrowserScrollView.h"

@interface GZEImageBrowserCell () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation GZEImageBrowserCell

- (void)setupSubviews
{
    self.contentView.backgroundColor = [UIColor blackColor];
    [self addGestures];
}

- (void)addGestures
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [singleTap requireGestureRecognizerToFail:pan];
    [doubleTap requireGestureRecognizerToFail:pan];
    
    [self addGestureRecognizer:singleTap];
    [self addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:pan];
}

- (void)singleTap:(UITapGestureRecognizer *)ges
{
    
}

- (void)doubleTap:(UITapGestureRecognizer *)ges
{
    
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    
}

- (GZEImageBrowserScrollView *)imageScrollView
{
    if (!_imageScrollView) {
        _imageScrollView = [[GZEImageBrowserScrollView alloc] init];
        _imageScrollView.delegate = self;
    }
    return _imageScrollView;
}

@end
