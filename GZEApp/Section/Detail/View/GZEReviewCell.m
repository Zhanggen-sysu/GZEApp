//
//  GZEReviewCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/30.
//

#import "GZEReviewCell.h"
#import "GZEReviewItem.h"
#import "GZEWrappingLabel.h"
#import "GZEAuthorDetails.h"
#import "GZECommonHelper.h"
#import "UIImageView+WebCache.h"

@interface GZEReviewCell ()

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) GZEWrappingLabel *contentLabel;

@property (nonatomic, strong) GZEReviewItem *model;

@end

@implementation GZEReviewCell

- (void)updateWithModel:(GZEReviewItem *)review magicColor:(UIColor *)magicColor
{
    self.model = review;
    self.contentView.backgroundColor = magicColor;
    self.contentLabel.backgroundColor = magicColor;
    [self.photoView sd_setImageWithURL:[GZECommonHelper getProfileUrl:review.authorDetails.avatarPath size:GZEProfileSize_w45] placeholderImage:kGetImage(@"default-poster")];
    self.nameLabel.text = review.authorDetails.username;
    self.scoreLabel.attributedText = [GZECommonHelper generateRatingString:review.authorDetails.rating.doubleValue starSize:12 space:1];
    self.detailLabel.text = review.createdAt;
    self.contentLabel.text = review.content;
    self.contentLabel.isExpand = review.isExpand;
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.photoView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.contentLabel];
}

- (void)defineLayout
{
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.top.equalTo(self.contentView).offset(5.f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.photoView.mas_trailing).offset(5.f);
        make.top.equalTo(self.photoView);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.scoreLabel.mas_trailing).offset(5);
        make.top.equalTo(self.scoreLabel).offset(5);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(5.f);
        make.bottom.equalTo(self.contentView).offset(-5.f);
        make.leading.equalTo(self.contentView);
    }];
}

- (UIImageView *)photoView
{
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.layer.masksToBounds = YES;
        _photoView.layer.cornerRadius = 16.f;
    }
    return _photoView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = kBoldFont(14.f);
    }
    return _nameLabel;
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
        _detailLabel.textColor = RGBColor(200, 200, 200);
        _detailLabel.font = kFont(10.f);
    }
    return _detailLabel;
}

- (GZEWrappingLabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[GZEWrappingLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 0)];
        _contentLabel.wrapText = nil;
        _contentLabel.wrapNumberOfLine = 6;
        _contentLabel.font = kFont(13.f);
        _contentLabel.textColor = [UIColor whiteColor];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"Expand " attributes:@{
            NSFontAttributeName: kFont(13.f),
            NSForegroundColorAttributeName: RGBColor(200, 200, 200),
        }]];
        _contentLabel.expandText = attri;
        WeakSelf(self)
        _contentLabel.didChangeHeight = ^(BOOL isExpand) {
            StrongSelfReturnNil(self)
            !self.didChangeHeight ?: self.didChangeHeight(isExpand);
        };
    }
    return _contentLabel;
}

@end
