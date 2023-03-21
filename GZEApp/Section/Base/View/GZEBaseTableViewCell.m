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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
