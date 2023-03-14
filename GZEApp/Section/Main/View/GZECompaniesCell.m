//
//  GZECompaniesCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZECompaniesCell.h"
#import "GZECompanySmallCell.h"

#import "GZECompanyListItem.h"

@interface GZECompaniesCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, copy) NSArray<GZECompanyListItem *> *model;

@end

@implementation GZECompaniesCell

- (void)updateWithModel:(NSArray<GZECompanyListItem *> *)model
{
    self.model = model;
    [self.collectionView reloadData];
}

- (CGSize)itemSize
{
    return CGSizeMake(70, 120);
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.editBtn];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15.f);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.f);
        make.right.equalTo(self.contentView).offset(-15.f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15.f);
        make.height.mas_equalTo([self itemSize].height * 2 + 15);
        make.bottom.equalTo(self.contentView).offset(-15.f);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.text = @"Explore";
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = [self itemSize];
        layout.minimumInteritemSpacing = 15;
        layout.minimumLineSpacing = 15;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 10);
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[GZECompanySmallCell class] forCellWithReuseIdentifier:NSStringFromClass([GZECompanySmallCell class])];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate, DataSource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZECompanySmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZECompanySmallCell class]) forIndexPath:indexPath];
    GZECompanyListItem *item = self.model[indexPath.row];
    [cell updateWithModel:item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.count > 8 ? 8 : self.model.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
