//
//  GZEDiscoverHeaderView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/14.
//

#import "GZEDiscoverHeaderView.h"
#import "Masonry.h"
#import "Macro.h"
#import "GZECustomButton.h"

@interface GZEDiscoverHeaderView ()

@property (nonatomic, strong) GZECustomButton *mediaButton;
@property (nonatomic, strong) GZECustomButton *genreButton;
@property (nonatomic, strong) GZECustomButton *sortButton;
@property (nonatomic, strong) GZECustomButton *languageButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *filterButton;

@end

@implementation GZEDiscoverHeaderView



- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
        [self defineLayout];
    }
    return self;
}

#pragma mark - Action
- (void)tapMediaButton
{
    [self.mediaButton setSelected:!self.mediaButton.isSelected];
    !self.didTapMediaButton ?: self.didTapMediaButton(!self.mediaButton.isSelected);
}

- (void)tapGenreButton
{
    
}

- (void)tapSortButton
{
    
}

- (void)tapLanguageButton
{
    
}

- (void)tapFilterButton
{
    
}

#pragma mark - UI
- (void)setupSubviews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.mediaButton];
    [self.contentView addSubview:self.genreButton];
    [self.contentView addSubview:self.sortButton];
    [self.contentView addSubview:self.languageButton];
    [self.contentView addSubview:self.filterButton];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15.f);
    }];
    [self.mediaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.left.equalTo(self.contentView);
        make.height.mas_equalTo(30.f);
    }];
    [self.genreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mediaButton.mas_right);
        make.top.bottom.width.equalTo(self.mediaButton);
    }];
    [self.languageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.genreButton.mas_right);
        make.top.bottom.width.equalTo(self.mediaButton);
    }];
    [self.sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.languageButton.mas_right);
        make.top.bottom.width.equalTo(self.mediaButton);
    }];
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sortButton.mas_right).offset(10.f);
        make.right.equalTo(self.contentView).offset(-15.f);
        make.centerY.equalTo(self.mediaButton);
        make.size.mas_equalTo(CGSizeMake(25.f, 25.f));
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.text = @"Discovery";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (GZECustomButton *)mediaButton
{
    if (!_mediaButton) {
        _mediaButton = [[GZECustomButton alloc] init];
        _mediaButton.titleLabel.font = kFont(14.f);
        [_mediaButton setTitle:@"Movie" forState:UIControlStateNormal];
        [_mediaButton setTitle:@"TV" forState:UIControlStateSelected];
        [_mediaButton setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
        [_mediaButton setTitleColor:RGBColor(0, 191, 255) forState:UIControlStateSelected];
        [_mediaButton setImage:kGetImage(@"switch-gray") forState:UIControlStateNormal];
        [_mediaButton setImage:kGetImage(@"switch-select") forState:UIControlStateSelected];
        [_mediaButton setImagePosition:GZEBtnImgPosition_Left spacing:5 contentAlign:GZEBtnContentAlign_Center contentOffset:0 imageSize:CGSizeZero titleSize:CGSizeZero];
        [_mediaButton addTarget:self action:@selector(tapMediaButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mediaButton;
}

- (GZECustomButton *)sortButton
{
    if (!_sortButton) {
        _sortButton = [[GZECustomButton alloc] init];
        _sortButton.titleLabel.font = kFont(14.f);
        [_sortButton setTitle:@"Sort" forState:UIControlStateNormal];
        [_sortButton setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
        [_sortButton setTitleColor:RGBColor(0, 191, 255) forState:UIControlStateSelected];
        [_sortButton setImage:kGetImage(@"arrow-down-gray") forState:UIControlStateNormal];
        [_sortButton setImage:kGetImage(@"arrow-down-select") forState:UIControlStateSelected];
        [_sortButton setImagePosition:GZEBtnImgPosition_Right spacing:5 contentAlign:GZEBtnContentAlign_Center contentOffset:0 imageSize:CGSizeMake(12, 12) titleSize:CGSizeZero];
    }
    return _sortButton;
}

- (GZECustomButton *)languageButton
{
    if (!_languageButton) {
        _languageButton = [[GZECustomButton alloc] init];
        _languageButton.titleLabel.font = kFont(14.f);
        [_languageButton setTitle:@"Language" forState:UIControlStateNormal];
        [_languageButton setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
        [_languageButton setTitleColor:RGBColor(0, 191, 255) forState:UIControlStateSelected];
        [_languageButton setImage:kGetImage(@"arrow-down-gray") forState:UIControlStateNormal];
        [_languageButton setImage:kGetImage(@"arrow-down-select") forState:UIControlStateSelected];
        [_languageButton setImagePosition:GZEBtnImgPosition_Right spacing:5 contentAlign:GZEBtnContentAlign_Center contentOffset:0 imageSize:CGSizeMake(12, 12) titleSize:CGSizeZero];
    }
    return _languageButton;
}

- (GZECustomButton *)genreButton
{
    if (!_genreButton) {
        _genreButton = [[GZECustomButton alloc] init];
        _genreButton.titleLabel.font = kFont(14.f);
        [_genreButton setTitle:@"Genre" forState:UIControlStateNormal];
        [_genreButton setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
        [_genreButton setTitleColor:RGBColor(0, 191, 255) forState:UIControlStateSelected];
        [_genreButton setImage:kGetImage(@"arrow-down-gray") forState:UIControlStateNormal];
        [_genreButton setImage:kGetImage(@"arrow-down-select") forState:UIControlStateSelected];
        [_genreButton setImagePosition:GZEBtnImgPosition_Right spacing:5 contentAlign:GZEBtnContentAlign_Center contentOffset:0 imageSize:CGSizeMake(12, 12) titleSize:CGSizeZero];
    }
    return _genreButton;
}

- (UIButton *)filterButton
{
    if (!_filterButton) {
        _filterButton = [[UIButton alloc] init];
        [_filterButton setImage:kGetImage(@"filter-gray") forState:UIControlStateNormal];
        [_filterButton setImage:kGetImage(@"filter-select") forState:UIControlStateSelected];
    }
    return _filterButton;
}

@end
