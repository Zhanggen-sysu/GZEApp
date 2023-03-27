//
//  GZEListSmallTableViewCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEListSmallTableViewCell.h"
#import "GZEListSmallTableViewCellModel.h"
#import "UIImageView+WebCache.h"
#import "GZECommonHelper.h"

@interface GZEListSmallTableViewCell ()

@property (nonatomic, strong) UIImageView *posterImg;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *scoreNumLabel;

@end

@implementation GZEListSmallTableViewCell

- (void)updateWithIndex:(NSInteger)index model:(GZEListSmallTableViewCellModel *)model
{
    self.indexLabel.text = [NSString stringWithFormat:@"%ld", index];
    self.titleLabel.text = model.title;
    self.scoreLabel.attributedText = model.score;
    self.scoreNumLabel.text = model.scoreNum;
    [self.posterImg sd_setImageWithURL:model.imgUrl placeholderImage:kGetImage(@"default-poster")];
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.posterImg];
    [self.contentView addSubview:self.indexLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.scoreNumLabel];
}

- (void)defineLayout
{
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(5.f);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(10.f);
    }];
    [self.posterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(46, 69));
        make.leading.equalTo(self.indexLabel.mas_trailing).offset(10.f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.posterImg.mas_trailing).offset(10.f);
        make.trailing.equalTo(self.contentView).offset(-10.f);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-5.f);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY).offset(5.f);
        make.leading.equalTo(self.titleLabel);
    }];
    [self.scoreNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.scoreLabel.mas_trailing).offset(5.f);
        make.centerY.equalTo(self.scoreLabel);
    }];
}

- (UILabel *)indexLabel
{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = kFont(12.f);
        _indexLabel.textColor = [UIColor whiteColor];
    }
    return _indexLabel;
}

- (UIImageView *)posterImg
{
    if (!_posterImg) {
        _posterImg = [[UIImageView alloc] init];
        _posterImg.layer.masksToBounds = YES;
        _posterImg.layer.cornerRadius = 3.f;
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

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
    }
    return _scoreLabel;
}

- (UILabel *)scoreNumLabel
{
    if (!_scoreNumLabel) {
        _scoreNumLabel = [[UILabel alloc] init];
        _scoreNumLabel.font = kFont(12.f);
        _scoreNumLabel.textColor = RGBColor(255, 215, 0);
    }
    return _scoreNumLabel;
}


@end
