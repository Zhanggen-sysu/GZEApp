//
//  GZEBaseCollectionViewCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZEBaseCollectionViewCell.h"

@implementation GZEBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
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
