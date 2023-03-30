//
//  GZEMovieNavBarView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEMovieNavBarView.h"
#import "GZEMovieDetailRsp.h"
#import "UIImageView+WebCache.h"
#import "GZECommonHelper.h"

@interface GZEMovieNavBarView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *posterIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *starLabel;
@property (nonatomic, strong) UILabel *scoreLabel;

@end

@implementation GZEMovieNavBarView

- (void)updateView:(BOOL)isHidden
{
    if (isHidden) {
        self.contentView.hidden = YES;
    } else {
        self.contentView.hidden = NO;
    }
}

- (void)updateWithModel:(GZEMovieDetailRsp *)model
{
    [self.posterIcon sd_setImageWithURL:[GZECommonHelper getPosterUrl:model.posterPath size:GZEPosterSize_w92] placeholderImage:kGetImage(@"default-poster")];
    self.titleLabel.text = model.title;
    self.starLabel.attributedText = [GZECommonHelper generateRatingString:model.voteAverage starSize:8 space:1];
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f", model.voteAverage];
}

- (void)setupSubviews
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.posterIcon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.starLabel];
    [self.contentView addSubview:self.scoreLabel];
}

- (void)defineLayout
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
    }];
    [self.posterIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(23, 34.5));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.posterIcon.mas_trailing).offset(5.f);
        make.top.equalTo(self.posterIcon);
    }];
    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.starLabel.mas_trailing).offset(5.f);
        make.bottom.equalTo(self.starLabel).offset(-2);
    }];
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.hidden = YES;
    }
    return _contentView;
}

- (UIImageView *)posterIcon
{
    if (!_posterIcon) {
        _posterIcon = [[UIImageView alloc] init];
    }
    return _posterIcon;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(12.f);
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)starLabel
{
    if (!_starLabel) {
        _starLabel = [[UILabel alloc] init];
    }
    return _starLabel;
}

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.font = kFont(10.f);
        _scoreLabel.textColor = RGBColor(255, 215, 0);
    }
    return _scoreLabel;
}

@end
