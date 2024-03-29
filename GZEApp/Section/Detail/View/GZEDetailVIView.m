//
//  GZEDetailVIView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEDetailVIView.h"
#import "GZEVISmallCell.h"
#import "GZETmdbImageRsp.h"
#import "GZEYTVideoRsp.h"
#import "GZECommonHelper.h"
#import "GZETmdbImageItem.h"
#import "GZECustomButton.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>

@interface GZEDetailVIView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *photoCollection;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GZECustomButton *seeAllBtn;
@property (nonatomic, strong) GZETmdbImageRsp *imgRsp;
@property (nonatomic, strong) GZEYTVideoRsp *videoModel;
@property (nonatomic, strong) UIColor *magicColor;
@property (nonatomic, copy) NSArray<GKPhoto *> *photos;

@end

@implementation GZEDetailVIView

- (void)updateWithImgModel:(GZETmdbImageRsp *)imgModel videoModel:(GZEYTVideoRsp *)videoModel magicColor:(nonnull UIColor *)magicColor
{
    if (!videoModel && imgModel.backdrops.count <= 0) {
        self.hidden = YES;
        return;
    }
    self.magicColor = magicColor;
    self.imgRsp = imgModel;
    self.videoModel = videoModel;
    self.backgroundColor = magicColor;
    self.photoCollection.backgroundColor = magicColor;
    [self.photoCollection reloadData];
    NSInteger count = self.imgRsp.backdrops.count + self.imgRsp.posters.count;
    if (count > 9) {
        [self.seeAllBtn setTitle:[NSString stringWithFormat:@"See All (%ld)", count] forState:UIControlStateNormal];
    } else {
        self.seeAllBtn.hidden = YES;
    }
}

- (void)didTapSeeAll
{
    
}

#pragma mark - UI
- (void)setupSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.photoCollection];
    [self addSubview:self.seeAllBtn];
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
    [self.seeAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15.f);
        make.centerY.equalTo(self.titleLabel);
    }];
}

#pragma mark - UICollectionViewDelegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZEVISmallCell *cell = (GZEVISmallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZEVISmallCell class]) forIndexPath:indexPath];
    if (indexPath.row == 0 && self.videoModel) {
        [cell updateWithVideo:self.videoModel magicColor:self.magicColor];
    } else {
        NSInteger index = self.videoModel ? indexPath.row-1 : indexPath.row;
        GZETmdbImageItem *backdrop = self.imgRsp.backdrops[index];
        [cell updateWithUrl:[GZECommonHelper getBackdropUrl:backdrop.filePath size:GZEBackdropSize_w780] aspectRatio:backdrop.aspectRatio];
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
    !self.didTapImage ?: self.didTapImage(self.photos, indexPath.item);
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

- (GZECustomButton *)seeAllBtn
{
    if (!_seeAllBtn) {
        _seeAllBtn = [[GZECustomButton alloc] init];
        _seeAllBtn.titleLabel.font = kFont(14.f);
        [_seeAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_seeAllBtn setImage:kGetImage(@"arrow-right-white") forState:UIControlStateNormal];
        [_seeAllBtn setImagePosition:GZEBtnImgPosition_Right spacing:5 contentAlign:GZEBtnContentAlign_Right contentOffset:0 imageSize:CGSizeZero titleSize:CGSizeZero];
        [_seeAllBtn addTarget:self action:@selector(didTapSeeAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeAllBtn;
}

- (NSArray<GKPhoto *> *)photos
{
    if (!_photos) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if (self.videoModel) {
            GKPhoto *video = [[GKPhoto alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            GZEVISmallCell *cell = (GZEVISmallCell *)[self.photoCollection cellForItemAtIndexPath:indexPath];
            video.sourceImageView = cell.imageView;
            video.videoUrl = [NSURL URLWithString:self.videoModel.url];
            [array addObject:video];
        }
        [self.imgRsp.backdrops enumerateObjectsUsingBlock:^(GZETmdbImageItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx + (self.videoModel ? 1 : 0) >= 10) {
                return;
            }
            GKPhoto *photo = [[GKPhoto alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx+1 inSection:0];
            GZEVISmallCell *cell = (GZEVISmallCell *)[self.photoCollection cellForItemAtIndexPath:indexPath];
            photo.sourceImageView = cell.imageView;
            photo.url = [GZECommonHelper getBackdropUrl:obj.filePath size:GZEBackdropSize_w780];
            photo.originUrl = [GZECommonHelper getBackdropUrl:obj.filePath size:GZEBackdropSize_original];
            [array addObject:photo];
        }];
        _photos = array;
    }
    return _photos;
}

- (CGSize)itemSize
{
    CGFloat width = 300;
    CGFloat height = 300 / 16 * 9;
    return CGSizeMake(width, height);
}

@end
