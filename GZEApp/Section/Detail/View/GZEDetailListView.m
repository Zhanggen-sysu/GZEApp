//
//  GZEDetailListView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEDetailListView.h"
#import "GZEDetailListCell.h"
#import "GZEDetailListViewVM.h"
#import "GZEDetailListCellVM.h"

@interface GZEDetailListView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *rightIcon;

@property (nonatomic, strong) GZEDetailListViewVM *viewModel;

@end

@implementation GZEDetailListView

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.titleLabel.text = title;
    }
    return self;
}

- (void)bindViewModel:(GZEDetailListViewVM *)viewModel
{
    self.viewModel = viewModel;
    self.titleLabel.text = viewModel.title;
    if (viewModel.magicColor) {
        self.backgroundColor = viewModel.magicColor;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.collectionView.backgroundColor = viewModel.magicColor;
        self.rightIcon.image = kGetImage(@"arrow-right-white");
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.rightIcon.image = kGetImage(@"arrow-right-gray");
    }
    self.rightIcon.hidden = self.viewModel.listArray.count <= 10;
    [self.collectionView reloadData];
    self.hidden = self.viewModel.listArray.count <= 0;
}

#pragma mark - UI
- (void)setupSubviews
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
    [self addSubview:self.rightIcon];
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
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15.f);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(14.f, 14.f));
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16.f);
        _titleLabel.textColor = [UIColor whiteColor];
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
        [_collectionView registerClass:[GZEDetailListCell class] forCellWithReuseIdentifier:NSStringFromClass([GZEDetailListCell class])];
    }
    return _collectionView;
}

- (UIImageView *)rightIcon
{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = kGetImage(@"arrow-right-white");
    }
    return _rightIcon;
}

#pragma mark - UICollectionViewDelegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZEDetailListCell *cell = (GZEDetailListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZEDetailListCell class]) forIndexPath:indexPath];
    GZEDetailListCellVM *model = self.viewModel.listArray[indexPath.item];
    [cell bindViewModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZEDetailListCellVM *model = self.viewModel.listArray[indexPath.item];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.listArray.count > 10 ? 10 : self.viewModel.listArray.count;
}

- (CGSize)itemSize
{
    CGFloat width = 154;
    CGFloat height = (int)(width * 1.5) + 64;
    return CGSizeMake(width, height);
}

@end
