//
//  GZEListTableViewCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEListTableViewCell.h"
#import "GZEListCollectionViewCell.h"
#import "GZEListCollectionFooterView.h"

@interface GZEListTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<GZEListCollectionViewModel *> *viewModel;

@end

@implementation GZEListTableViewCell

- (void)updateWithModel:(NSArray<GZEListCollectionViewModel *> *)viewModel
{
    self.viewModel = viewModel;
    [self.collectionView reloadData];
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.collectionView];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15.f);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.f);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(300.f);
        make.bottom.equalTo(self.contentView).offset(-15.f);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.text = @"Lists";
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(320, 300);
        layout.minimumLineSpacing = 15;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 15);
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[GZEListCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([GZEListCollectionViewCell class])];
        [_collectionView registerClass:[GZEListCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([GZEListCollectionFooterView class])];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate, DataSource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZEListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZEListCollectionViewCell class]) forIndexPath:indexPath];
    GZEListCollectionViewModel *item = self.viewModel[indexPath.row];
    [cell updateWithModel:item];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(65, 300);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        GZEListCollectionFooterView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([GZEListCollectionFooterView class]) forIndexPath:indexPath];
        return view;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
