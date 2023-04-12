//
//  GZEPeopleDetailImageView.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/12.
//

#import "GZEPeopleDetailImageView.h"
#import "GZECommonHelper.h"
#import "GZECustomButton.h"
#import "GZETmdbImageRsp.h"
#import "GZETagImageRsp.h"
#import "GZEVISmallCell.h"
#import "GZETmdbImageItem.h"

@interface GZEPeopleDetailImageView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *photoCollection;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GZECustomButton *seeAllBtn;
@property (nonatomic, strong) GZETmdbImageRsp *images;
@property (nonatomic, strong) GZETagImageRsp *taggedImages;

@end

@implementation GZEPeopleDetailImageView

- (void)updateWithImages:(GZETmdbImageRsp *)images taggedImages:(GZETagImageRsp *)taggedImages
{
    if (images.profiles.count <= 0 && taggedImages.results.count <= 0) {
        self.hidden = YES;
        return;
    }
    self.images = images;
    self.taggedImages = taggedImages;
    [self.photoCollection reloadData];
    NSInteger count = images.profiles.count + taggedImages.results.count;
    if (count > 10) {
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
        make.height.mas_equalTo(300 * 9 / 16);
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
    GZETmdbImageItem *item = nil;
    if (indexPath.row < self.images.profiles.count) {
        item = self.images.profiles[indexPath.row];
    } else {
        item = self.taggedImages.results[indexPath.row - self.images.profiles.count];
    }
    if (item.aspectRatio < 1) {
        [cell updateWithUrl:[GZECommonHelper getPosterUrl:item.filePath size:GZEPosterSize_w342] aspectRatio:item.aspectRatio];
    } else {
        [cell updateWithUrl:[GZECommonHelper getBackdropUrl:item.filePath size:GZEBackdropSize_w780] aspectRatio:item.aspectRatio];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(self.images.profiles.count + self.taggedImages.results.count, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    GZETmdbImageItem *item = nil;
    if (indexPath.row < self.images.profiles.count) {
        item = self.images.profiles[indexPath.row];
    } else {
        item = self.taggedImages.results[indexPath.row - self.images.profiles.count];
    }
    CGFloat height = 300 * 9 / 16;
    if (item.aspectRatio < 1) {
        return CGSizeMake(height / 3 * 2, height);
    }
    return CGSizeMake(300, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16.f);
        _titleLabel.text = @"Images";
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UICollectionView *)photoCollection
{
    if (!_photoCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
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
        [_seeAllBtn setTitleColor:RGBColor(128, 128, 128) forState:UIControlStateNormal];
        [_seeAllBtn setImage:kGetImage(@"arrow-right-gray") forState:UIControlStateNormal];
        [_seeAllBtn setImagePosition:GZEBtnImgPosition_Right spacing:5 contentAlign:GZEBtnContentAlign_Right contentOffset:0 imageSize:CGSizeZero titleSize:CGSizeZero];
        [_seeAllBtn addTarget:self action:@selector(didTapSeeAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeAllBtn;
}

@end

