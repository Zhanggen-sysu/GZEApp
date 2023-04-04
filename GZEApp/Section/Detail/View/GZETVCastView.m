//
//  GZETVCastView.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/3.
//

#import "GZETVCastView.h"
#import "GZECrewCastRsp.h"
#import "GZECastSmallCell.h"

static NSInteger kCastCount = 4;
@interface GZETVCastView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) GZECrewCastRsp *model;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *rightIcon;

@property (nonatomic, strong) UIColor *magicColor;

@end

@implementation GZETVCastView

- (void)updateWithModel:(GZECrewCastRsp *)model magicColor:(nonnull UIColor *)magicColor
{
    if (model.cast.count <= 0) {
        self.hidden = YES;
        return;
    }
    self.magicColor = magicColor;
    self.backgroundColor = magicColor;
    self.collectionView.backgroundColor = magicColor;
    self.model = model;
    [self.collectionView reloadData];
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
        _titleLabel.text = @"Cast & Crew";
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = [self itemSize];
        layout.minimumLineSpacing = 15.f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 15.f);
        [_collectionView registerClass:[GZECastSmallCell class] forCellWithReuseIdentifier:NSStringFromClass([GZECastSmallCell class])];
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
    GZECastSmallCell *cell = (GZECastSmallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZECastSmallCell class]) forIndexPath:indexPath];
    GZECastItem *model = self.model.cast[indexPath.row];
    [cell updateWithModel:model magicColor:self.magicColor];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.cast.count > 10 ? 10 : self.model.cast.count;
}

- (CGSize)itemSize
{
    CGFloat width = (int)(SCREEN_WIDTH / kCastCount);
    CGFloat height = width * 1.5 + 70.f;
    return CGSizeMake(width, height);
}


@end
