//
//  GZEBaseView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZEBaseView.h"

@implementation GZEBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
        [self defineLayout];
    }
    return self;
}



- (void)setupSubviews
{
    NSAssert(NO, @"Must override");
}

- (void)defineLayout
{
    NSAssert(NO, @"Must override");
}

@end
