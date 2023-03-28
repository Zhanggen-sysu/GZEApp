//
//  GZEMovieVIView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEMovieVIView.h"
#import "GZEVISmallCell.h"
#import "GZEMovieImageRsp.h"
#import "GZEMovieVideoItem.h"
#import "GZECommonHelper.h"
#import "GZEBackdropItem.h"

@interface GZEMovieVIView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *photoCollection;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightArrowIcon;
@property (nonatomic, strong) GZEMovieImageRsp *imgRsp;
@property (nonatomic, strong) GZEMovieVideoItem *videoModel;

@end

@implementation GZEMovieVIView

- (void)updateWithImgModel:(GZEMovieImageRsp *)imgModel videoModel:(GZEMovieVideoItem *)videoModel magicColor:(nonnull UIColor *)magicColor
{
    self.imgRsp = imgModel;
    self.videoModel = videoModel;
    self.backgroundColor = magicColor;
    self.photoCollection.backgroundColor = magicColor;
    [self.photoCollection reloadData];
}

#pragma mark - UI
- (void)setupSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.photoCollection];
    [self addSubview:self.rightArrowIcon];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10.f);
        make.leading.equalTo(self).offset(15.f);
        make.trailing.equalTo(self).offset(-15.f);
    }];
    [self.photoCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.leading.equalTo(self).offset(15.f);
        make.trailing.equalTo(self);
        make.height.mas_equalTo([self itemSize].height);
        make.bottom.equalTo(self).offset(-10.f);
    }];
    [self.rightArrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15.f);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(14.f, 14.f));
    }];
}

#pragma mark - UICollectionViewDelegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZEVISmallCell *cell = (GZEVISmallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZEVISmallCell class]) forIndexPath:indexPath];
    if (indexPath.row == 0 && self.videoModel) {
        [cell updateWithKey:self.videoModel.key];
    } else {
        NSInteger index = self.videoModel ? indexPath.row-1 : indexPath.row;
        GZEBackdropItem *backdrop = self.imgRsp.backdrops[index];
        [cell updateWithUrl:[GZECommonHelper getBackdropUrl:backdrop.filePath size:GZEBackdropSize_w300]];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = (self.videoModel ? 1 : 0) + self.imgRsp.backdrops.count;
    return count > 10 ? 10 : count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16.f);
        _titleLabel.text = @"Videos & Images";
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UICollectionView *)photoCollection
{
    if (!_photoCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = [self itemSize];
        
        _photoCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _photoCollection.showsHorizontalScrollIndicator = NO;
        _photoCollection.delegate = self;
        _photoCollection.dataSource = self;
        _photoCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 15.f);
        [_photoCollection registerClass:[GZEVISmallCell class] forCellWithReuseIdentifier:NSStringFromClass([GZEVISmallCell class])];
    }
    return _photoCollection;
}

- (UIImageView *)rightArrowIcon
{
    if (!_rightArrowIcon) {
        _rightArrowIcon = [[UIImageView alloc] init];
        _rightArrowIcon.image = kGetImage(@"arrow-right-white");
    }
    return _rightArrowIcon;
}

- (CGSize)itemSize
{
    CGFloat width = 300;
    CGFloat height = 300 / 16.f * 9;
    return CGSizeMake(width, height);
}

@end
