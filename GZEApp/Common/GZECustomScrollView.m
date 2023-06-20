//
//  GZECustomScrollView.m
//  GZEApp
//
//  Created by GenZhang on 2023/6/14.
//

#import "GZECustomScrollView.h"

@implementation GZECustomScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
