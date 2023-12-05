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
    NSString *assert = [NSString stringWithFormat:@"Must override %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    NSAssert(NO, assert);
}

- (void)defineLayout
{
    NSString *assert = [NSString stringWithFormat:@"Must override %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    NSAssert(NO, assert);
}

- (void)bindViewModel:(id)viewModel
{
    
}

@end
