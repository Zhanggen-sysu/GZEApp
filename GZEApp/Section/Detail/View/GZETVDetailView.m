//
//  GZETVDetailView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZETVDetailView.h"
#import "GZECommonHelper.h"
#import "GZECustomButton.h"
#import "GZETVDetailRsp.h"
#import <TTGTextTagCollectionView.h>
#import "UIImageView+WebCache.h"

@interface GZETVDetailView ()

@property (nonatomic, strong) UIImageView *posterView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tagLineLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) TTGTextTagCollectionView *genresView;
@property (nonatomic, strong) UILabel *overviewLabel;
@property (nonatomic, strong) UILabel *countryLabel;
@property (nonatomic, strong) UILabel *directorLabel;
@property (nonatomic, strong) GZECustomButton *showMoreBtn;

@end

@implementation GZETVDetailView

- (void)updateWithModel:(GZETVDetailRsp *)model magicColor:(nonnull UIColor *)magicColor
{
    [self.posterView sd_setImageWithURL:[GZECommonHelper getPosterUrl:model.posterPath size:GZEPosterSize_w500] placeholderImage:kGetImage(@"default-poster")];
    self.titleLabel.text = model.name;
    if (model.tagline.length > 0) {
        self.tagLineLabel.hidden = NO;
        self.tagLineLabel.text = model.tagline;
    } else {
        self.tagLineLabel.hidden = YES;
    }
    NSMutableAttributedString *ratingStr = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = kGetImage(@"starFullIcon");
    attach.bounds = CGRectMake(0, -2, 20.f, 20.f);
    NSDictionary *attri = @{
        NSFontAttributeName: kFont(16.f),
        NSForegroundColorAttributeName: RGBColor(255, 215, 0)
    };
    [ratingStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    [ratingStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %.1f", model.voteAverage] attributes:attri]];
    self.scoreLabel.attributedText = ratingStr;
    if (model.detailText.length > 0) {
        
    }
}

- (void)didTapShowMore
{
    self.showMoreBtn.selected = !self.showMoreBtn.selected;
    if (self.showMoreBtn.selected) {
        
    } else {
        
    }
}

- (void)setupSubviews
{
    [self addSubview:self.posterView];
    [self addSubview:self.stackView];
}

- (void)defineLayout
{
    [self.posterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.mas_equalTo(SCREEN_WIDTH / 2 * 3);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15.f);
        make.trailing.equalTo(self).offset(-15.f);
        make.top.equalTo(self).offset(10.f);
        make.bottom.equalTo(self).offset(-10.f);
    }];
}

- (UIImageView *)posterView
{
    if (!_posterView) {
        _posterView = [[UIImageView alloc] init];
    }
    return _posterView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = kBoldFont(18);
    }
    return _titleLabel;
}

- (UILabel *)tagLineLabel
{
    if (!_tagLineLabel) {
        _tagLineLabel = [[UILabel alloc] init];
        _tagLineLabel.textColor = [UIColor whiteColor];
        _tagLineLabel.font = kFont(16);
    }
    return _titleLabel;
}

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
    }
    return _scoreLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.font = kFont(14);
    }
    return _detailLabel;
}

- (UILabel *)overviewLabel
{
    if (!_overviewLabel) {
        _overviewLabel = [[UILabel alloc] init];
        _overviewLabel.textColor = [UIColor whiteColor];
        _overviewLabel.font = kFont(14);
        _overviewLabel.numberOfLines = 0;
    }
    return _overviewLabel;
}

- (UILabel *)countryLabel
{
    if (!_countryLabel) {
        _countryLabel = [[UILabel alloc] init];
    }
    return _countryLabel;
}

- (UILabel *)directorLabel
{
    if (!_directorLabel) {
        _directorLabel = [[UILabel alloc] init];
    }
    return _detailLabel;
}

- (GZECustomButton *)showMoreBtn
{
    if (!_showMoreBtn) {
        _showMoreBtn = [[GZECustomButton alloc] init];
        _showMoreBtn.titleLabel.font = kFont(14.f);
        [_showMoreBtn setTitle:@"See more info" forState:UIControlStateNormal];
        [_showMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showMoreBtn setImage:kGetImage(@"arrow-down-full-white") forState:UIControlStateNormal];
        [_showMoreBtn setImage:kGetImage(@"arrow-up-full-white") forState:UIControlStateSelected];
        [_showMoreBtn setImagePosition:GZEBtnImgPosition_Right spacing:5 contentAlign:GZEBtnContentAlign_Center contentOffset:0 imageSize:CGSizeMake(15, 15) titleSize:CGSizeZero];
        [_showMoreBtn addTarget:self action:@selector(didTapShowMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showMoreBtn;
}

- (UIStackView *)stackView
{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
            self.titleLabel,
            self.tagLineLabel,
            self.scoreLabel,
            self.detailLabel,
            self.genresView,
            self.overviewLabel,
            self.countryLabel,
            self.directorLabel,
            self.showMoreBtn,
        ]];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = 10.f;
    }
    return _stackView;
}

@end
