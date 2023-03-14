//
//  GZEBaseTableViewCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZEBaseTableViewCell.h"

@implementation GZEBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
