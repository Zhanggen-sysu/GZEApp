//
//  GZEDiscoverSortCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/16.
//

#import "GZEDiscoverSortCell.h"

@interface GZEDiscoverSortCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectArrow;

@end

@implementation GZEDiscoverSortCell

- (void)setupSubviews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectArrow];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15.0f);
    }];
    
    [self.selectArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15.0f);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLabel.textColor = RGBColor(0, 191, 255);
        self.selectArrow.hidden = NO;
    } else {
        self.titleLabel.textColor = RGBColor(128, 128, 128);
        self.selectArrow.hidden = YES;
    }
}

- (void)updateWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(15.f);
    }
    return _titleLabel;
}

- (UIImageView *)selectArrow
{
    if (!_selectArrow) {
        _selectArrow = [[UIImageView alloc] init];
        _selectArrow.image = kGetImage(@"selected-icon");
    }
    return _selectArrow;
}



@end
