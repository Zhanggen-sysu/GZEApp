//
//  GZESearchTableViewCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import "GZESearchTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GZESearchCellViewModel.h"
#import "GZEPaddingLabel.h"

@interface GZESearchTableViewCell ()

@property (nonatomic, strong) UIImageView *poster;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *scoreNum;
@property (nonatomic, strong) GZEPaddingLabel *typeLabel;

@end

@implementation GZESearchTableViewCell

- (void)updateWithModel:(GZESearchCellViewModel *)viewModel
{
    [self.poster sd_setImageWithURL:viewModel.posterUrl placeholderImage:kGetImage(@"default-poster")];
    self.titleLabel.text = viewModel.title;
    self.detailLabel.text = viewModel.detail;
    self.scoreLabel.attributedText = viewModel.stars;
    self.scoreNum.text = viewModel.score;
    self.typeLabel.text = viewModel.mediaType;
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.poster];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.scoreNum];
    [self.contentView addSubview:self.typeLabel];
}

- (void)defineLayout
{
    [self.poster mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(46, 69));
        make.leading.equalTo(self.contentView).offset(15.f);
    }];
    [self.scoreNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.scoreLabel);
        make.leading.equalTo(self.scoreLabel.mas_trailing).offset(5.f);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
        make.leading.equalTo(self.titleLabel);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.leading.equalTo(self.poster.mas_trailing).offset(10.f);
        make.trailing.equalTo(self.contentView).offset(-15.f);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.typeLabel.mas_trailing).offset(5.f);
        make.centerY.equalTo(self.typeLabel);
        make.trailing.equalTo(self.titleLabel);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(10.f);
        make.leading.equalTo(self.titleLabel);
    }];
    [self.typeLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.typeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (UIImageView *)poster
{
    if (!_poster) {
        _poster = [[UIImageView alloc] init];
        _poster.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _poster;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(14.f);
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont(10.f);
        _detailLabel.textColor = RGBColor(128, 128, 128);
        _detailLabel.backgroundColor = [UIColor whiteColor];
    }
    return _detailLabel;
}

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.backgroundColor = [UIColor whiteColor];
    }
    return _scoreLabel;
}

- (UILabel *)scoreNum
{
    if (!_scoreNum) {
        _scoreNum = [[UILabel alloc] init];
        _scoreNum.font = kFont(12.f);
        _scoreNum.textColor = RGBColor(255, 215, 0);
        _scoreNum.backgroundColor = [UIColor whiteColor];
    }
    return _scoreNum;
}

- (GZEPaddingLabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[GZEPaddingLabel alloc] init];
        _typeLabel.font = kFont(10.f);
        _typeLabel.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        _typeLabel.backgroundColor = RGBColor(245, 245, 245);
        _typeLabel.textColor = RGBColor(128, 128, 128);
        _typeLabel.layer.cornerRadius = 2;
        _typeLabel.layer.masksToBounds = YES;
    }
    return _typeLabel;
}

@end
