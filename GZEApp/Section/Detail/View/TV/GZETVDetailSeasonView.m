//
//  GZETVDetailSeasonView.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/3.
//

#import "GZETVDetailSeasonView.h"
#import "GZESeasonItem.h"
#import "GZETVDetailSeasonCell.h"

@interface GZETVDetailSeasonView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<GZESeasonItem *> *seasons;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIColor *magicColor;

@end

@implementation GZETVDetailSeasonView

- (void)updateWithModel:(NSArray<GZESeasonItem *> *)model magicColor:(nonnull UIColor *)magicColor
{
    self.seasons = model;
    self.collectionView.backgroundColor = magicColor;
    self.backgroundColor = magicColor;
    [self.collectionView reloadData];
}

- (CGSize)itemSize
{
    CGFloat width = 154;
    CGFloat height = (int)(width * 1.5) + 40;
    return CGSizeMake(width, height);
}

- (void)setupSubviews
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10.f);
        make.leading.equalTo(self).offset(15.f);
        make.trailing.equalTo(self).offset(-15.f);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.leading.equalTo(self.titleLabel);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(-10.f);
        make.height.mas_equalTo([self itemSize].height);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16.f);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"Seasons";
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = [self itemSize];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 15.f);
        [_collectionView registerClass:[GZETVDetailSeasonCell class] forCellWithReuseIdentifier:NSStringFromClass([GZETVDetailSeasonCell class])];
    }
    return _collectionView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZETVDetailSeasonCell *cell = (GZETVDetailSeasonCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZETVDetailSeasonCell class]) forIndexPath:indexPath];
    GZESeasonItem *model = self.seasons[indexPath.row];
    [cell updateWithModel:model magicColor:self.magicColor];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.seasons.count;
}


@end
