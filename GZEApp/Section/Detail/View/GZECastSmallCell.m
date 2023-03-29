//
//  GZECastSmallCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZECastSmallCell.h"
#import "GZECastItem.h"
#import "GZECommonHelper.h"
#import "UIImageView+WebCache.h"
#import "UIView+GZEExtension.h"

@interface GZECastSmallCell ()

@property (nonatomic, strong) GZECastItem *model;

@property (nonatomic, strong) UIImageView *avatarImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *characterLabel;

@end

@implementation GZECastSmallCell

- (void)updateWithModel:(GZECastItem *)model magicColor:(nonnull UIColor *)magicColor
{
    self.model = model;
    self.contentView.backgroundColor = magicColor;
    [self.avatarImg sd_setImageWithURL:[GZECommonHelper getProfileUrl:model.profilePath size:GZEProfileSize_w185]  placeholderImage:kGetImage(@"default-poster")];
    self.nameLabel.text = model.name;
    self.characterLabel.text = model.character;
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.avatarImg];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.characterLabel];
}

- (void)defineLayout
{
    [self.avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(5.f);
        make.trailing.equalTo(self.contentView).offset(-5.f);
        make.height.equalTo(self.contentView.mas_width).offset(-10.f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImg.mas_bottom).offset(10.f);
        make.leading.trailing.equalTo(self.avatarImg);
    }];
    [self.characterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10.f);
        make.leading.trailing.equalTo(self.avatarImg);
    }];
}

- (UIImageView *)avatarImg
{
    if (!_avatarImg) {
        _avatarImg = [[UIImageView alloc] init];
        _avatarImg.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImg.layer.masksToBounds = YES;
        _avatarImg.layer.cornerRadius = (self.contentView.width - 10) / 2;
    }
    return _avatarImg;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = kFont(14.f);
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)characterLabel
{
    if (!_characterLabel) {
        _characterLabel = [[UILabel alloc] init];
        _characterLabel.font = kFont(12.f);
        _characterLabel.textAlignment = NSTextAlignmentCenter;
        _characterLabel.textColor = RGBColor(200, 200, 200);
    }
    return _characterLabel;
}


@end