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
        self.backgroundColor = [UIColor whiteColor];
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

@end
