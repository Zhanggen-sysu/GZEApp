//
//  GZEDetailListCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEDetailListCell.h"
#import "GZECommonHelper.h"
#import "GZEDetailListCellVM.h"
#import "UIImageView+WebCache.h"
#import "GZEGlobalConfig.h"

@interface GZEDetailListCell ()

@property (nonatomic, strong) UIImageView *posterImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rateLabel;

@end

@implementation GZEDetailListCell

- (void)bindViewModel:(GZEDetailListCellVM *)viewModel
{
    self.contentView.backgroundColor = viewModel.magicColor;
    self.nameLabel.text = viewModel.name;
    self.rateLabel.attributedText = viewModel.ratingString;
    [self.posterImg sd_setImageWithURL:viewModel.posterUrl placeholderImage:kGetImage(@"default-poster")];
}

#pragma mark - UI
- (void)setupSubviews
{
    [self.contentView addSubview:self.posterImg];
    [self.contentView addSubview:self.rateLabel];
    [self.contentView addSubview:self.nameLabel];
}

- (void)defineLayout
{
    [self.posterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(1.5);
    }];
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.posterImg.mas_bottom).offset(5.f);
        make.trailing.leading.equalTo(self.posterImg);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rateLabel.mas_bottom).offset(5.f);
        make.leading.trailing.equalTo(self.posterImg);
    }];
}

- (UIImageView *)posterImg
{
    if (!_posterImg) {
        _posterImg = [[UIImageView alloc] init];
        _posterImg.contentMode = UIViewContentModeScaleAspectFill;
        _posterImg.layer.masksToBounds = YES;
        _posterImg.layer.cornerRadius = 5;
    }
    return _posterImg;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFont(14.f);
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)rateLabel
{
    if (!_rateLabel) {
        _rateLabel = [[UILabel alloc] init];
        _rateLabel.font = kFont(14.f);
        _rateLabel.textColor = RGBColor(200, 200, 200);
    }
    return _rateLabel;
}

@end
