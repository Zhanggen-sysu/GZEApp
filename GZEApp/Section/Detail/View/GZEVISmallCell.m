//
//  GZEVISmallCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEVISmallCell.h"
#import "UIImageView+WebCache.h"
#import "YTPlayerView.h"

@interface GZEVISmallCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) YTPlayerView *playerView;

@end

@implementation GZEVISmallCell

- (void)setupSubviews
{
   [self.contentView addSubview:self.imageView];
}

- (void)defineLayout
{
   [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.contentView);
   }];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (YTPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [[YTPlayerView alloc] init];
    }
    return _playerView;
}

- (void)updateWithUrl:(NSURL *)url
{
    [self.playerView removeFromSuperview];
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.imageView sd_setImageWithURL:url placeholderImage:kGetImage(@"default-backdrop")];
}

- (void)updateWithKey:(NSString *)key
{
    [self.imageView removeFromSuperview];
    [self.contentView addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.playerView loadWithVideoId:key];
}

@end
