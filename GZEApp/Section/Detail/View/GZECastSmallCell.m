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
#import "GZERoleItem.h"
#import "GZEGlobalConfig.h"

@interface GZECastSmallCell ()

@property (nonatomic, strong) GZECastItem *model;

@property (nonatomic, strong) UIImageView *avatarImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *characterLabel;

@end

@implementation GZECastSmallCell

- (void)bindViewModel:(GZECastItem *)viewModel
{
    RAC(self.contentView, backgroundColor) = RACObserve([GZEGlobalConfig shareConfig], magicColor);
    [self.avatarImg sd_setImageWithURL:[GZECommonHelper getProfileUrl:viewModel.profilePath size:GZEProfileSize_w185]  placeholderImage:kGetImage(@"default-poster")];
    self.nameLabel.text = viewModel.name;
    self.characterLabel.text = viewModel.roleString;
}

- (void)updateWithModel:(GZECastItem *)model magicColor:(nonnull UIColor *)magicColor
{
    self.model = model;
    self.contentView.backgroundColor = magicColor;
    [self.avatarImg sd_setImageWithURL:[GZECommonHelper getProfileUrl:model.profilePath size:GZEProfileSize_w185]  placeholderImage:kGetImage(@"default-poster")];
    self.nameLabel.text = model.name;
    if (model.character.length > 0) {
        self.characterLabel.text = model.character;
    } else {
        NSMutableString *text = [[NSMutableString alloc] init];
        [model.roles enumerateObjectsUsingBlock:^(GZERoleItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [text appendString:obj.character];
            if (model.roles.count-1 != idx) {
                [text appendString:@" / "];
            }
        }];
        self.characterLabel.text = text;
    }
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
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(1.5);
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
        _avatarImg.layer.cornerRadius = 5.f;
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
