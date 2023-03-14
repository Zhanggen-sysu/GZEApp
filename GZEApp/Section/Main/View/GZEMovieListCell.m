//
//  GZEMovieListCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZEMovieListCell.h"
#import "UIImageView+WebCache.h"


@interface GZEMovieListCell ()

@property (nonatomic, strong) UIImageView *posterImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UILabel *overviewLabel;
@property (nonatomic, strong) UIView *backView;

@end

@implementation GZEMovieListCell

- (void)setupSubviews
{
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.posterImg];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.subLabel];
    [self.backView addSubview:self.overviewLabel];
}

- (void)defineLayout
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.posterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backView).offset(15.f);
        make.top.equalTo(self.backView).offset(10.f);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 3, SCREEN_WIDTH / 2));
        make.bottom.lessThanOrEqualTo(self.backView).offset(-10.f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.posterImg.mas_trailing).offset(15.f);
        make.top.equalTo(self.backView).offset(10.f);
        make.trailing.equalTo(self.backView).offset(-15.f);
    }];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.leading.trailing.equalTo(self.titleLabel);
    }];
    [self.overviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subLabel.mas_bottom).offset(10.f);
        make.leading.trailing.equalTo(self.titleLabel);
        make.bottom.lessThanOrEqualTo(self.backView).offset(-10.f);
    }];
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

- (UIImageView *)posterImg
{
    if (!_posterImg) {
        _posterImg = [[UIImageView alloc] init];
    }
    return _posterImg;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16.f);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)subLabel
{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
        _subLabel.font = kFont(14.f);
    }
    return _subLabel;
}

- (UILabel *)overviewLabel
{
    if (!_overviewLabel) {
        _overviewLabel = [[UILabel alloc] init];
        _overviewLabel.font = kFont(12.f);
        _overviewLabel.textColor = RGBColor(128, 128, 128);
        _overviewLabel.numberOfLines = 0;
    }
    return _overviewLabel;
}


@end
