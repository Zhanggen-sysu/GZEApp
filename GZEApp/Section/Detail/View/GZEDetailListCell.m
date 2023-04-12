//
//  GZEDetailListCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEDetailListCell.h"
#import "GZEMovieListItem.h"
#import "GZETVListItem.h"
#import "GZECommonHelper.h"
#import "UIImageView+WebCache.h"

@interface GZEDetailListCell ()

@property (nonatomic, strong) UIImageView *posterImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rateLabel;

@end

@implementation GZEDetailListCell

- (void)updateWithModel:(GZEMovieListItem *)model magicColor:(UIColor *)magicColor
{
    self.contentView.backgroundColor = magicColor;
    self.nameLabel.text = model.title;
    [self.posterImg sd_setImageWithURL:[GZECommonHelper getPosterUrl:model.posterPath size:GZEPosterSize_w342] placeholderImage:kGetImage(@"default-poster")];
    self.rateLabel.attributedText = [self ratingString:model.voteAverage];
}

- (void)updateWithTVModel:(GZETVListItem *)model magicColor:(UIColor *)magicColor
{
    self.contentView.backgroundColor = magicColor;
    self.nameLabel.text = model.name;
    [self.posterImg sd_setImageWithURL:[GZECommonHelper getPosterUrl:model.posterPath size:GZEPosterSize_w342] placeholderImage:kGetImage(@"default-poster")];

    self.rateLabel.attributedText = [self ratingString:model.voteAverage];
}

- (NSAttributedString *)ratingString:(double)voteAverage
{
    NSMutableAttributedString *ratingStr = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = kGetImage(@"starFullIcon");
    attach.bounds = CGRectMake(0, -2, 14.f, 14.f);
    NSDictionary *attri = @{
        NSFontAttributeName: kFont(14.f),
        NSForegroundColorAttributeName: RGBColor(255, 215, 0)
    };
    [ratingStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    [ratingStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %.1f", voteAverage] attributes:attri]];
    return ratingStr;
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
