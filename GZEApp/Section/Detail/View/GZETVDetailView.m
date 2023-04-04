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
#import "GZETVDetailLineView.h"
#import "GZEGenreItem.h"
#import "GZEEpisodeToAir.h"

@interface GZETVDetailView ()

@property (nonatomic, strong) GZETVDetailRsp *model;

@property (nonatomic, strong) UIImageView *posterView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tagLineLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) TTGTextTagCollectionView *genresView;
@property (nonatomic, strong) TTGTextTagStyle *genresStyle;
@property (nonatomic, strong) UILabel *overviewLabel;
@property (nonatomic, strong) GZETVDetailLineView *countryView;
@property (nonatomic, strong) GZETVDetailLineView *directorView;
@property (nonatomic, strong) GZETVDetailLineView *statusView;
@property (nonatomic, strong) GZETVDetailLineView *episodeView;
@property (nonatomic, strong) GZETVDetailLineView *homeView;
@property (nonatomic, strong) GZETVDetailLineView *lastView;
@property (nonatomic, strong) GZETVDetailLineView *nextView;
@property (nonatomic, strong) GZETVDetailLineView *networkView;
@property (nonatomic, strong) GZETVDetailLineView *companyView;
@property (nonatomic, strong) GZECustomButton *showMoreBtn;

@end

@implementation GZETVDetailView

- (void)updateWithModel:(GZETVDetailRsp *)model magicColor:(nonnull UIColor *)magicColor
{
    self.model = model;
    self.backgroundColor = magicColor;
    self.stackView.backgroundColor = magicColor;
    [self.posterView sd_setImageWithURL:[GZECommonHelper getPosterUrl:model.posterPath size:GZEPosterSize_w500] placeholderImage:kGetImage(@"default-poster")];
    self.titleLabel.text = model.name;
    if (model.tagline.length > 0) {
        self.tagLineLabel.hidden = NO;
        self.tagLineLabel.text = model.tagline;
    } else {
        self.tagLineLabel.hidden = YES;
    }
    if (model.subTitleText.length > 0) {
        self.subTitleLabel.hidden = NO;
        self.subTitleLabel.text = model.subTitleText;
    } else {
        self.subTitleLabel.hidden = YES;
    }
    NSMutableAttributedString *ratingStr = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = kGetImage(@"starFullIcon");
    attach.bounds = CGRectMake(0, -5, 20.f, 20.f);
    NSDictionary *attri = @{
        NSFontAttributeName: kFont(16.f),
        NSForegroundColorAttributeName: RGBColor(255, 215, 0)
    };
    [ratingStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    [ratingStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %.1f", model.voteAverage] attributes:attri]];
    self.scoreLabel.attributedText = ratingStr;
    if (model.detailText.length > 0) {
        self.detailLabel.hidden = NO;
        self.detailLabel.text = model.detailText;
    } else {
        self.detailLabel.hidden = YES;
    }
    if (model.genres.count > 0) {
        self.genresView.hidden = NO;
        self.genresStyle.backgroundColor = [GZECommonHelper changeColor:magicColor deeper:NO degree:30];
        [model.genres enumerateObjectsUsingBlock:^(GZEGenreItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TTGTextTagStringContent *text = [TTGTextTagStringContent contentWithText:obj.name];
            text.textFont = kFont(14.f);
            text.textColor = [UIColor whiteColor];
            TTGTextTag *textTag = [TTGTextTag tagWithContent:text style:self.genresStyle];
            [self.genresView addTag:textTag];
        }];
        [self.genresView reload];
    } else {
        self.genresView.hidden = YES;
    }
    if (model.overview.length > 0) {
        self.overviewLabel.text = model.overview;
        self.overviewLabel.hidden = NO;
    } else {
        self.overviewLabel.hidden = YES;
    }
    if (model.countryText.length > 0) {
        self.countryView.hidden = NO;
        [self.countryView updateWithDetail:model.countryText];
    } else {
        self.countryView.hidden = YES;
    }
    if (model.directorText.length > 0) {
        self.directorView.hidden = NO;
        [self.directorView updateWithDetail:model.directorText];
    } else {
        self.directorView.hidden = YES;
    }
    [self.episodeView updateWithDetail:[NSString stringWithFormat:@"%ld %@ and %ld %@", model.numberOfSeasons, model.numberOfSeasons > 1 ? @"seasons" : @"season", model.numberOfEpisodes, model.numberOfEpisodes > 1 ? @"episodes" : @"episode"]];
    [self.homeView updateWithLinkDetail:model.homepage];
    [self.statusView updateWithDetail:model.status];
    [self.lastView updateWithDetail:model.lastAirDate];
    [self.nextView updateWithDetail:model.nextEpisodeToAir ? model.nextEpisodeToAir.airDate : @""];
    [self.networkView updateWithDetail:model.networkText];
    [self.companyView updateWithDetail:model.companyText];
}

- (void)didTapShowMore
{
    self.showMoreBtn.selected = !self.showMoreBtn.selected;
    if (self.showMoreBtn.selected) {
        self.episodeView.hidden = NO;
        if (self.model.homepage.length > 0) {
            self.homeView.hidden = NO;
        }
        if (self.model.status.length > 0) {
            self.statusView.hidden = NO;
        }
        if (self.model.lastAirDate.length > 0) {
            self.lastView.hidden = NO;
        }
        if (self.model.nextEpisodeToAir) {
            self.nextView.hidden = NO;
        }
        if (self.model.companyText.length > 0) {
            self.companyView.hidden = NO;
        }
        if (self.model.networkText.length > 0) {
            self.networkView.hidden = NO;
        }
    } else {
        self.episodeView.hidden = YES;
        self.homeView.hidden = YES;
        self.statusView.hidden = YES;
        self.lastView.hidden = YES;
        self.nextView.hidden = YES;
        self.companyView.hidden = YES;
        self.networkView.hidden = YES;
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
        make.top.equalTo(self.posterView.mas_bottom).offset(10.f);
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
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)tagLineLabel
{
    if (!_tagLineLabel) {
        _tagLineLabel = [[UILabel alloc] init];
        _tagLineLabel.textColor = [UIColor whiteColor];
        _tagLineLabel.font = kFont(16);
        _tagLineLabel.numberOfLines = 0;
    }
    return _tagLineLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor whiteColor];
        _subTitleLabel.font = kBoldFont(16);
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scoreLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = kFont(16);
        _detailLabel.numberOfLines = 0;
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
        _overviewLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _overviewLabel;
}

- (GZETVDetailLineView *)countryView
{
    if (!_countryView) {
        _countryView = [[GZETVDetailLineView alloc] initWithTitle:@"Countries"];
    }
    return _countryView;
}
    
- (GZETVDetailLineView *)directorView
{
    if (!_directorView) {
        _directorView = [[GZETVDetailLineView alloc] initWithTitle:@"Create By"];
    }
    return _directorView;
}

- (GZETVDetailLineView *)episodeView
{
    if (!_episodeView) {
        _episodeView = [[GZETVDetailLineView alloc] initWithTitle:@"Episode Info"];
        _episodeView.hidden = YES;
    }
    return _episodeView;
}

- (GZETVDetailLineView *)homeView
{
    if (!_homeView) {
        _homeView = [[GZETVDetailLineView alloc] initWithTitle:@"Homepage"];
        _homeView.hidden = YES;
    }
    return _homeView;
}

- (GZETVDetailLineView *)networkView
{
    if (!_networkView) {
        _networkView = [[GZETVDetailLineView alloc] initWithTitle:@"Network"];
        _networkView.hidden = YES;
    }
    return _networkView;
}

- (GZETVDetailLineView *)companyView
{
    if (!_companyView) {
        _companyView = [[GZETVDetailLineView alloc] initWithTitle:@"Companies"];
        _companyView.hidden = YES;
    }
    return _companyView;
}

- (GZETVDetailLineView *)nextView
{
    if (!_nextView) {
        _nextView = [[GZETVDetailLineView alloc] initWithTitle:@"Next Episode Air Date"];
        _nextView.hidden = YES;
    }
    return _nextView;
}

- (GZETVDetailLineView *)lastView
{
    if (!_lastView) {
        _lastView = [[GZETVDetailLineView alloc] initWithTitle:@"Last Episode Air Date"];
        _lastView.hidden = YES;
    }
    return _lastView;
}

- (GZETVDetailLineView *)statusView
{
    if (!_statusView) {
        _statusView = [[GZETVDetailLineView alloc] initWithTitle:@"Status"];
        _statusView.hidden = YES;
    }
    return _statusView;
}

- (TTGTextTagCollectionView *)genresView
{
    if (!_genresView) {
        _genresView = [[TTGTextTagCollectionView alloc] init];
        _genresView.enableTagSelection = NO;
        _genresView.alignment = TTGTagCollectionAlignmentCenter;
    }
    return _genresView;
}

- (TTGTextTagStyle *)genresStyle
{
    if (!_genresStyle) {
        _genresStyle = [[TTGTextTagStyle alloc] init];
        _genresStyle.borderWidth = 0;
        _genresStyle.shadowOffset = CGSizeMake(0, 0);
        _genresStyle.shadowRadius = 0;
        _genresStyle.extraSpace = CGSizeMake(8, 3);
    }
    return _genresStyle;
}

- (GZECustomButton *)showMoreBtn
{
    if (!_showMoreBtn) {
        _showMoreBtn = [[GZECustomButton alloc] init];
        _showMoreBtn.titleLabel.font = kFont(16.f);
        [_showMoreBtn setTitle:@"See more info" forState:UIControlStateNormal];
        [_showMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showMoreBtn setImage:kGetImage(@"arrow-down-full-white") forState:UIControlStateNormal];
        [_showMoreBtn setImage:kGetImage(@"arrow-up-full-white") forState:UIControlStateSelected];
        [_showMoreBtn setImagePosition:GZEBtnImgPosition_Right spacing:5 contentAlign:GZEBtnContentAlign_Left contentOffset:10 imageSize:CGSizeMake(15, 15) titleSize:CGSizeZero];
        [_showMoreBtn addTarget:self action:@selector(didTapShowMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showMoreBtn;
}

- (UIStackView *)stackView
{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
            self.titleLabel,
            self.subTitleLabel,
            self.tagLineLabel,
            self.scoreLabel,
            self.detailLabel,
            self.genresView,
            self.overviewLabel,
            self.directorView,
            self.countryView,
            self.companyView,
            self.networkView,
            self.statusView,
            self.episodeView,
            self.lastView,
            self.nextView,
            self.homeView,
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
