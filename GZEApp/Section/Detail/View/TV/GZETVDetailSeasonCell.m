//
//  GZETVDetailSeasonCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/3.
//

#import "GZETVDetailSeasonCell.h"
#import "GZESeasonItem.h"
#import "GZECommonHelper.h"
#import "UIImageView+WebCache.h"

@interface GZETVDetailSeasonCell ()

@property (nonatomic, strong) UIImageView *posterImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation GZETVDetailSeasonCell

- (void)updateWithModel:(GZESeasonItem *)model magicColor:(UIColor *)magicColor
{
    self.backgroundColor = magicColor;
    self.contentView.backgroundColor = magicColor;
    [self.posterImg sd_setImageWithURL:[GZECommonHelper getPosterUrl:model.posterPath size:GZEPosterSize_w342] placeholderImage:kGetImage(@"default-poster")];
    self.titleLabel.text = model.name;
    if (model.airDate.length > 0) {
        self.detailLabel.text = [NSString stringWithFormat:@"%@ (%ld episodes)", model.airDate, model.episodeCount];
    }
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.posterImg];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
}

- (void)defineLayout
{
    [self.posterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(1.5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.posterImg.mas_bottom).offset(5.f);
        make.trailing.leading.equalTo(self.posterImg);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
        make.leading.trailing.equalTo(self.posterImg);
    }];
}

- (UIImageView *)posterImg
{
    if (!_posterImg) {
        _posterImg = [[UIImageView alloc] init];
        _posterImg.contentMode = UIViewContentModeScaleAspectFit;
        _posterImg.layer.masksToBounds = YES;
        _posterImg.layer.cornerRadius = 5;
    }
    return _posterImg;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(14.f);
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont(12.f);
        _detailLabel.textColor = RGBColor(200, 200, 200);
    }
    return _detailLabel;
}


@end
