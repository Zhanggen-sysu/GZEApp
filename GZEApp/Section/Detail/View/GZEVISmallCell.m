//
//  GZEVISmallCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEVISmallCell.h"
#import "UIImageView+WebCache.h"
#import "GZEYTVideoRsp.h"
#import "GZEPaddingLabel.h"
#import "GZEVISmallCellVM.h"
#import "GZEGlobalConfig.h"

@interface GZEVISmallCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *videoBg;
@property (nonatomic, strong) GZEPaddingLabel *tagLabel;
@property (nonatomic, strong) UIImageView *playImg;

@end

@implementation GZEVISmallCell

- (void)setupSubviews
{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.videoBg];
    [self.videoBg addSubview:self.tagLabel];
    [self.videoBg addSubview:self.playImg];
}

- (void)defineLayout
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.videoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.videoBg).offset(10.f);
    }];
    [self.playImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoBg);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIView *)videoBg
{
    if (!_videoBg) {
        _videoBg = [[UIView alloc] init];
    }
    return _videoBg;
}

- (GZEPaddingLabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[GZEPaddingLabel alloc] init];
        _tagLabel.edgeInsets = UIEdgeInsetsMake(2, 4, 2, 4);
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.backgroundColor = RGBColor(0, 191, 255);
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.layer.cornerRadius = 2;
        _tagLabel.font = kFont(12.f);
    }
    return _tagLabel;
}

- (UIImageView *)playImg
{
    if (!_playImg) {
        _playImg = [[UIImageView alloc] init];
        _playImg.image = kGetImage(@"play-video-white");
    }
    return _playImg;
}

- (void)bindViewModel:(GZEVISmallCellVM *)viewModel
{
    self.videoBg.hidden = viewModel.isVideo;
    UIImage *placeHolder = viewModel.isPoster ? kGetImage(@"default-poster") : kGetImage(@"default-backdrop");
    [self.imageView sd_setImageWithURL:viewModel.url placeholderImage:placeHolder];
    self.tagLabel.text = viewModel.videoType;
//    self.tagLabel.backgroundColor = viewModel.;
}

- (void)updateWithUrl:(NSURL *)url aspectRatio:(double)aspectRatio
{
    self.videoBg.hidden = YES;
    UIImage *placeHolder = aspectRatio > 1 ? kGetImage(@"default-backdrop") : kGetImage(@"default-poster");
    [self.imageView sd_setImageWithURL:url placeholderImage:placeHolder];
}

- (void)updateWithVideo:(GZEYTVideoRsp *)model magicColor:(UIColor *)magicColor
{
    self.videoBg.hidden = NO;
    self.tagLabel.backgroundColor = magicColor;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailURL] placeholderImage:kGetImage(@"default-backdrop")];
    self.tagLabel.text = model.videoType;
    
}

@end
