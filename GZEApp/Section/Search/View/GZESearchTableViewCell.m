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
#import "GZECommonHelper.h"

@interface GZESearchTableViewCell ()

@property (nonatomic, strong) UIImageView *poster;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *scoreView;
@property (nonatomic, strong) UIView *detailView;
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
    self.typeLabel.text = viewModel.typeText;
    if (viewModel.mediaType == GZEMediaType_Person) {
        self.scoreView.hidden = YES;
    } else {
        self.scoreLabel.attributedText = [GZECommonHelper generateRatingString:viewModel.voteAverage starSize:12 space:1];
        self.scoreNum.text = [NSString stringWithFormat:@"%.1f", viewModel.voteAverage];
        self.scoreView.hidden = NO;
    }
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.poster];
    [self.scoreView addSubview:self.scoreLabel];
    [self.scoreView addSubview:self.scoreNum];
    [self.detailView addSubview:self.typeLabel];
    [self.detailView addSubview:self.detailLabel];
    [self.contentView addSubview:self.stackView];
}

- (void)defineLayout
{
    [self.poster mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(46, 69));
        make.leading.equalTo(self.contentView).offset(15.f);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.poster.mas_trailing).offset(10.f);
        make.trailing.equalTo(self.contentView).offset(-15.f);
    }];
    [self.scoreNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.scoreLabel);
        make.leading.equalTo(self.scoreLabel.mas_trailing).offset(5.f);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.equalTo(self.scoreView);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.typeLabel.mas_trailing).offset(5.f);
        make.centerY.equalTo(self.typeLabel);
        make.trailing.equalTo(self.detailView);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.equalTo(self.detailView);
    }];
    [self.typeLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.typeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (UIView *)detailView
{
    if (!_detailView) {
        _detailView = [[UIView alloc] init];
    }
    return _detailView;
}

- (UIView *)scoreView
{
    if (!_scoreView) {
        _scoreView = [[UIView alloc] init];
    }
    return _scoreView;
}

- (UIStackView *)stackView
{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
            self.titleLabel,
            self.scoreView,
            self.detailView,
        ]];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = 5;
    }
    return _stackView;
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
