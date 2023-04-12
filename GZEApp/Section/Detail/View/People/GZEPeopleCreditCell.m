//
//  GZEPeopleCreditCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/7.
//

#import "GZEPeopleCreditCell.h"
#import "GZEMediaCast.h"
#import "GZEMediaCrew.h"
#import "UIImageView+WebCache.h"
#import "GZECommonHelper.h"

@interface GZEPeopleCreditCell ()

@property (nonatomic, strong) UIImageView *posterView;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation GZEPeopleCreditCell

- (void)updateWithCastModel:(GZEMediaCast *)cast
{
    [self.posterView sd_setImageWithURL:[GZECommonHelper getPosterUrl:cast.posterPath size:GZEPosterSize_w342] placeholderImage:kGetImage(@"default-poster")];
    if (cast.voteAverage > 0) {
        self.tagLabel.hidden = NO;
        self.tagLabel.text = [NSString stringWithFormat:@"%.1f", cast.voteAverage];
    } else {
        self.tagLabel.hidden = YES;
    }
    if ([cast.mediaType isEqualToString:@"tv"]) {
        self.titleLabel.text = cast.name;
    } else if ([cast.mediaType isEqualToString:@"movie"]) {
        self.titleLabel.text = cast.title;
    }
    self.detailLabel.text = cast.character;
}

- (void)updateWithCrewModel:(GZEMediaCrew *)crew
{
    [self.posterView sd_setImageWithURL:[GZECommonHelper getPosterUrl:crew.posterPath size:GZEPosterSize_w342] placeholderImage:kGetImage(@"default-poster")];
    if (crew.voteAverage > 0) {
        self.tagLabel.hidden = NO;
        self.tagLabel.text = [NSString stringWithFormat:@"%.1f", crew.voteAverage];
    } else {
        self.tagLabel.hidden = YES;
    }
    if ([crew.mediaType isEqualToString:@"tv"]) {
        self.titleLabel.text = crew.name;
    } else if ([crew.mediaType isEqualToString:@"movie"]) {
        self.titleLabel.text = crew.title;
    }
    self.detailLabel.text = crew.job;
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.posterView];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
}

- (void)defineLayout
{
    [self.posterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(1.5);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.posterView).offset(10.f);
        make.size.mas_equalTo(CGSizeMake(25, 15));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.posterView.mas_bottom).offset(5.f);
        make.trailing.leading.equalTo(self.posterView);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
        make.leading.trailing.equalTo(self.posterView);
    }];
}

- (UIImageView *)posterView
{
    if (!_posterView) {
        _posterView = [[UIImageView alloc] init];
        _posterView.contentMode = UIViewContentModeScaleAspectFill;
        _posterView.layer.masksToBounds = YES;
        _posterView.layer.cornerRadius = 5;
    }
    return _posterView;
}

- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.backgroundColor = RGBColor(0, 191, 255);
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.layer.cornerRadius = 2;
        _tagLabel.font = kFont(12.f);
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(14.f);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont(14.f);
        _detailLabel.textColor = RGBColor(128, 128, 128);
    }
    return _detailLabel;
}

@end
