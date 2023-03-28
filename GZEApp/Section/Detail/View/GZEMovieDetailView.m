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
#import "GZEProductionCountry.h"
#import <TTGTextTagCollectionView.h>
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
@property (nonatomic, strong) TTGTextTagCollectionView *genresView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *overviewLabel;

@end

@implementation GZEMovieDetailView

- (void)updateWithModel:(GZEMovieDetailRsp *)rsp magicColor:(nonnull UIColor *)magicColor
{
    self.detail = rsp;
    self.detailContent.backgroundColor = magicColor;
    [self.backdropImg sd_setImageWithURL:[GZECommonHelper getBackdropUrl:self.detail.backdropPath size:GZEBackdropSize_w780] placeholderImage:kGetImage(@"default-backdrop")];
    [self.posterImg sd_setImageWithURL:[GZECommonHelper getPosterUrl:self.detail.posterPath size:GZEPosterSize_w342] placeholderImage:kGetImage(@"default-poster")];
    if (self.detail.title.length > 0) {
        self.titleLabel.text = self.detail.title;
    } else {
        self.titleLabel.text = @"(Not Initialized Yet)";
    }
    
    if (self.detail.originalLanguage.length > 0 && ![self.detail.originalLanguage isEqualToString:@"en"] && self.detail.originalTitle.length > 0) {
        NSMutableString *subTitle = [[NSMutableString alloc] initWithString:self.detail.originalTitle];
        if (self.detail.releaseDate.length > 0) {
            [subTitle appendString:[[NSString alloc] initWithFormat:@" (%@)", [self.detail.releaseDate substringToIndex:4]]];
        }
        self.subTitleLabel.text = subTitle;
        self.subTitleLabel.hidden = NO;
    } else {
        self.subTitleLabel.hidden = YES;
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
            NSFontAttributeName: kBoldFont(16.f),
            NSForegroundColorAttributeName: RGBColor(255, 215, 0),
        }]];
        [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@" / 10" attributes:@{
            NSFontAttributeName: kFont(12.f),
            NSForegroundColorAttributeName: RGBColor(245, 245, 245),
        }]];
        self.ratingLabel.hidden = NO;
        self.ratingLabel.attributedText = attri;
    } else {
        self.ratingLabel.hidden = YES;
    }
    
    if (self.detail.genres.count > 0) {
        TTGTextTagStyle *style = [[TTGTextTagStyle alloc] init];
        style.backgroundColor = [GZECommonHelper changeColor:magicColor deeper:NO degree:30];
        style.borderWidth = 0;
        style.shadowOffset = CGSizeMake(0, 0);
        style.shadowRadius = 0;
        style.extraSpace = CGSizeMake(8, 3);
        [self.detail.genres enumerateObjectsUsingBlock:^(GZEGenreItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TTGTextTagStringContent *text = [TTGTextTagStringContent contentWithText:obj.name];
            text.textFont = kFont(12.f);
            text.textColor = [UIColor whiteColor];
            TTGTextTag *textTag = [TTGTextTag tagWithContent:text style:style];
            [self.genresView addTag:textTag];
        }];
        [self.genresView reload];
        self.genresView.hidden = NO;
    } else {
        self.genresView.hidden = YES;
    }
    
    if (self.detail.productionCountries.count > 0 || self.detail.releaseDate.length > 0 || self.detail.runtime > 0) {
        NSMutableString *detail = [[NSMutableString alloc] initWithString:self.detail.productionCountries.count > 0 ? self.detail.productionCountries.firstObject.iso3166_1 : @""];
        if (self.detail.releaseDate.length > 0) {
            [detail appendString:detail.length > 0 ? [NSString stringWithFormat:@" · %@", self.detail.releaseDate] : self.detail.releaseDate];
        }
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
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.stackView);
    }];
    [self.tagLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.stackView);
    }];
    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.stackView);
    }];
    [self.genresView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel)
    {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = kBoldFont(14.f);
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.textColor = [UIColor whiteColor];
    }
    return _subTitleLabel;
}

- (UILabel *)tagLineLabel
{
    if (!_tagLineLabel)
    {
        _tagLineLabel = [[UILabel alloc] init];
        _tagLineLabel.font = kFont(14.f);
        _tagLineLabel.textColor = RGBColor(245, 245, 245);
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

- (TTGTextTagCollectionView *)genresView
{
    if (!_genresView)
    {
        _genresView = [[TTGTextTagCollectionView alloc] init];
        _genresView.enableTagSelection = NO;
    }
    return _genresView;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont(12.f);
        _detailLabel.numberOfLines = 0;
        _detailLabel.textColor = [UIColor whiteColor];
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
        _overviewLabel.textColor = [UIColor whiteColor];
    }
    return _overviewLabel;
}

- (UIStackView *)stackView
{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
            self.titleLabel,
            self.subTitleLabel,
            self.tagLineLabel,
            self.ratingLabel,
            self.genresView,
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
