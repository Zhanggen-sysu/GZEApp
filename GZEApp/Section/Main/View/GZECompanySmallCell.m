//
//  GZECompanySmallCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZECompanySmallCell.h"
#import "UIView+GZEExtension.h"
#import "GZECompanyListItem.h"
#import "GZECommonHelper.h"
#import "UIImageView+WebCache.h"

@interface GZECompanySmallCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation GZECompanySmallCell

- (void)updateWithModel:(GZECompanyListItem *)model
{
    [self.icon sd_setImageWithURL:[GZECommonHelper getLogoUrl:model.logoPath size:GZELogoSize_w154] placeholderImage:kGetImage(@"default-logo")];
    self.nameLabel.text = model.providerName;
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.icon];
}

- (void)defineLayout
{
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(self.icon.mas_width);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.icon.mas_bottom).offset(10.f);
    }];
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 5;
    }
    return _icon;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = RGBColor(128, 128, 128);
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

@end
