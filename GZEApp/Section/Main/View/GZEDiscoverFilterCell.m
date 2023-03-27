//
//  GZEDiscoverFilterCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/17.
//

#import "GZEDiscoverFilterCell.h"
#import "NSString+GZEExtension.h"

@interface GZEDiscoverFilterCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GZEDiscoverFilterCell

- (void)updateWithString:(NSString *)text
{
    CGSize size = [text textSizeIn:CGSizeMake(SCREEN_WIDTH - 20, 30) font:kFont(15.f)];
    if (size.width > (SCREEN_WIDTH - 60) / 3.f - 10) {
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumScaleFactor = 0.1;
    } else {
        self.titleLabel.adjustsFontSizeToFitWidth = NO;
    }
    self.titleLabel.text = text;
}

- (void)setupSubviews
{
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.f;
    self.contentView.backgroundColor = RGBColor(245, 245, 245);
    [self.contentView addSubview:self.titleLabel];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(5.f);
        make.trailing.equalTo(self.contentView).offset(-5.f);
    }];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = RGBColor(0, 191, 255);
    } else {
        self.titleLabel.textColor = RGBColor(128, 128, 128);
        self.contentView.backgroundColor = RGBColor(245, 245, 245);
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(15.f);
        _titleLabel.textColor = RGBColor(128, 128, 128);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
