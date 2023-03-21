//
//  GZEDiscoverCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/14.
//

#import "GZEDiscoverCell.h"
#import "UIImageView+WebCache.h"
#import "GZEDiscoverCellViewModel.h"
#import "GZECommonHelper.h"

@interface GZEDiscoverCell ()

@property (nonatomic, strong) UIImageView *posterImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *backdropImg;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *scoreNumLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation GZEDiscoverCell

- (void)updateWithModel:(GZEDiscoverCellViewModel *)viewModel
{
    [self.posterImg sd_setImageWithURL:viewModel.posterUrl placeholderImage:kGetImage(@"default-poster")];
    [self.backdropImg sd_setImageWithURL:viewModel.backdropUrl placeholderImage:kGetImage(@"default-backdrop")];
    self.nameLabel.text = viewModel.name;
    self.scoreLabel.attributedText = viewModel.stars;
    self.scoreNumLabel.text = viewModel.score;
    self.detailLabel.text = viewModel.detail;
    self.contentLabel.text = viewModel.overview;
}

- (CGSize)posterSize
{
    CGFloat width = (SCREEN_WIDTH - 40) * 3 / 11.f;
    CGFloat height = width * 3 / 2.f;
    return CGSizeMake(width, height);
}

- (CGSize)backdropSize
{
    CGFloat width = [self posterSize].width * 8 / 3.f;
    CGFloat height = width * 9 / 16.f;
    return CGSizeMake(width, height);
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.posterImg];
    [self.contentView addSubview:self.backdropImg];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.scoreNumLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)defineLayout
{
    [self.posterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self posterSize]);
        make.top.left.equalTo(self.contentView).offset(15.f);
    }];
    [self.backdropImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self backdropSize]);
        make.left.equalTo(self.posterImg.mas_right).offset(10.f);
        make.top.equalTo(self.posterImg);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterImg);
        make.right.equalTo(self.backdropImg);
        make.top.equalTo(self.posterImg.mas_bottom).offset(10.f);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterImg);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10.f);
    }];
    [self.scoreNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreLabel);
        make.left.equalTo(self.scoreLabel.mas_right).offset(5.f);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(5.f);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10.f);
        make.bottom.equalTo(self.contentView).offset(-5.f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5f);
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.contentView);
    }];
}

- (UIImageView *)posterImg
{
    if (!_posterImg) {
        _posterImg = [[UIImageView alloc] init];
        _posterImg.layer.cornerRadius = 5.f;
        _posterImg.layer.masksToBounds = YES;
    }
    return _posterImg;
}

- (UIImageView *)backdropImg
{
    if (!_backdropImg) {
        _backdropImg = [[UIImageView alloc] init];
        _backdropImg.layer.cornerRadius = 5.f;
        _backdropImg.layer.masksToBounds = YES;
    }
    return _backdropImg;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kBoldFont(16.f);
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
    }
    return _scoreLabel;
}

- (UILabel *)scoreNumLabel
{
    if (!_scoreNumLabel) {
        _scoreNumLabel = [[UILabel alloc] init];
        _scoreNumLabel.font = kFont(14.f);
        _scoreNumLabel.textColor = RGBColor(255, 215, 0);
    }
    return _scoreNumLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont(12.f);
        _detailLabel.textColor = RGBColor(128, 128, 128);
    }
    return _detailLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kFont(14.f);
        _contentLabel.numberOfLines = 3;
    }
    return _contentLabel;
}

@end
