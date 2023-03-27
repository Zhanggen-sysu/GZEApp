//
//  GZEMovieDetailView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEMovieDetailView.h"
#import "GZEMovieDetailRsp.h"
#import "UIImageView+WebCache.h"
#import "GZECommonHelper.h"
#import "GZEGenreItem.h"
#import "GZEPaddingLabel.h"
#import "Macro.h"

@interface GZEMovieDetailView ()

@property (nonatomic, strong) GZEMovieDetailRsp *detail;

@property (nonatomic, strong) UIImageView *backdropImg;
@property (nonatomic, strong) UIImageView *posterImg;

@property (nonatomic, strong) UIView *detailContent;

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tagLineLabel;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UILabel *genreLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *overviewLabel;

@end

@implementation GZEMovieDetailView

- (void)updateWithModel:(GZEMovieDetailRsp *)rsp
{
    self.detail = rsp;
    [self.backdropImg sd_setImageWithURL:[GZECommonHelper getBackdropUrl:self.detail.backdropPath size:GZEBackdropSize_w780] placeholderImage:kGetImage(@"default-backdrop")];
    [self.posterImg sd_setImageWithURL:[GZECommonHelper getPosterUrl:self.detail.posterPath size:GZEPosterSize_w342] placeholderImage:kGetImage(@"default-poster")];
    if (self.detail.title.length > 0) {
        self.titleLabel.text = self.detail.title;
    } else {
        self.titleLabel.text = @"(Not Initialized Yet)";
    }
    if (self.detail.tagline.length > 0) {
        self.tagLineLabel.hidden = NO;
        self.tagLineLabel.text = self.detail.tagline;
    } else {
        self.tagLineLabel.hidden = YES;
    }
    if (self.detail.voteAverage > 0) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithAttributedString:[GZECommonHelper generateRatingString:self.detail.voteAverage starSize:20 space:2]];
        [attri appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f", self.detail.voteAverage] attributes:@{
            NSFontAttributeName: kBoldFont(14.f),
            NSForegroundColorAttributeName: RGBColor(255, 215, 0),
        }]];
        [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@" / 10" attributes:@{
            NSFontAttributeName: kFont(10.f),
            NSForegroundColorAttributeName: RGBColor(128, 128, 128),
        }]];
        self.ratingLabel.hidden = NO;
        self.ratingLabel.attributedText = attri;
    } else {
        self.ratingLabel.hidden = YES;
    }
    
    if (self.detail.genres.count > 0) {
        NSMutableAttributedString *genresStr = [[NSMutableAttributedString alloc] init];
        [self.detail.genres enumerateObjectsUsingBlock:^(GZEGenreItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        }];
        self.genreLabel.hidden = NO;
        self.genreLabel.attributedText = genresStr;
    } else {
        self.genreLabel.hidden = YES;
    }
    if (self.detail.releaseDate.length > 0 || self.detail.runtime > 0) {
        NSMutableString *detail = [[NSMutableString alloc] initWithString:self.detail.releaseDate.length > 0 ? self.detail.releaseDate : @""];
        if (self.detail.runtime > 0) {
            NSString *runtime = [NSString stringWithFormat:@"%ldhrs %ldmin", self.detail.runtime/60, self.detail.runtime%60];
            [detail appendString:detail.length > 0 ? [NSString stringWithFormat:@" · %@", runtime] : runtime];
        }
        self.detailLabel.text = detail;
        self.detailLabel.hidden = NO;
    } else {
        self.detailLabel.hidden = YES;
    }
    self.overviewLabel.text = self.detail.overview;
}

#pragma mark - UI
- (void)setupSubviews
{
    [self addSubview:self.backdropImg];
    [self addSubview:self.detailContent];
    [self.detailContent addSubview:self.posterImg];
    [self.detailContent addSubview:self.stackView];
    [self.detailContent addSubview:self.overviewLabel];
}

- (void)defineLayout
{
    [self.backdropImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.mas_equalTo(SCREEN_WIDTH / 16.0 * 9);
    }];
    [self.detailContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backdropImg.mas_bottom);
        make.leading.trailing.bottom.equalTo(self);
    }];
    [self.posterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(128, 192));
        make.top.equalTo(self.backdropImg.mas_bottom).offset(-32.f);
        make.leading.equalTo(self).offset(15.f);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.posterImg.mas_trailing).offset(10.f);
        make.trailing.equalTo(self).offset(-15.f);
        make.top.equalTo(self.backdropImg.mas_bottom).offset(10.f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.stackView);
    }];
    [self.tagLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.stackView);
    }];
    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.stackView);
    }];
    [self.genreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.stackView);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.stackView);
    }];
    [self.overviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15.f);
        make.trailing.equalTo(self).offset(-15.f);
        make.bottom.equalTo(self.detailContent).offset(-10.f);
        make.top.greaterThanOrEqualTo(self.posterImg.mas_bottom).offset(10.f);
        make.top.greaterThanOrEqualTo(self.stackView.mas_bottom).offset(10.f);
    }];
}

- (UIImageView *)backdropImg
{
    if (!_backdropImg) {
        _backdropImg = [[UIImageView alloc] init];
    }
    return _backdropImg;
}

- (UIView *)detailContent
{
    if (!_detailContent)
    {
        _detailContent = [[UIView alloc] init];
        _detailContent.backgroundColor = [UIColor whiteColor];
    }
    return _detailContent;
}

- (UIImageView *)posterImg
{
    if (!_posterImg) {
        _posterImg = [[UIImageView alloc] init];
        _posterImg.layer.masksToBounds = YES;
        _posterImg.layer.cornerRadius = 10.f;
    }
    return _posterImg;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16.f);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)tagLineLabel
{
    if (!_tagLineLabel)
    {
        _tagLineLabel = [[UILabel alloc] init];
        _tagLineLabel.font = kFont(14.f);
        _tagLineLabel.textColor = RGBColor(128, 128, 128);
        _tagLineLabel.numberOfLines = 0;
    }
    return _tagLineLabel;
}

- (UILabel *)ratingLabel
{
    if (!_ratingLabel)
    {
        _ratingLabel = [[UILabel alloc] init];
    }
    return _ratingLabel;
}

- (UILabel *)genreLabel
{
    if (!_genreLabel)
    {
        _genreLabel = [[UILabel alloc] init];
        _genreLabel.numberOfLines = 0;
    }
    return _genreLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont(14.f);
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UILabel *)overviewLabel
{
    if (!_overviewLabel)
    {
        _overviewLabel = [[UILabel alloc] init];
        _overviewLabel.font = kFont(14.f);
        _overviewLabel.numberOfLines = 0;
    }
    return _overviewLabel;
}

- (UIStackView *)stackView
{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
            self.titleLabel,
            self.tagLineLabel,
            self.ratingLabel,
            self.genreLabel,
            self.detailLabel,
        ]];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = 10.f;
    }
    return _stackView;
}

@end
