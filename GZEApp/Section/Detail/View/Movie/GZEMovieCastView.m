//
//  GZEMovieCastView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEMovieCastView.h"
#import "GZECrewCastRsp.h"
#import "GZECastSmallCell.h"
#import "GZECastItem.h"
#import "GZECrewItem.h"

static NSInteger kCastCount = 4;

@interface GZEMovieCastView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) GZECrewCastRsp *model;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *castCollection;
@property (nonatomic, strong) UILabel *directorLabel;
@property (nonatomic, strong) UIButton *seeAllBtn;
@property (nonatomic, strong) UIImageView *rightIcon;

@property (nonatomic, strong) UIColor *magicColor;

@end

@implementation GZEMovieCastView

- (void)updateWithModel:(GZECrewCastRsp *)model magicColor:(nonnull UIColor *)magicColor
{
    if (model.cast.count <= 0) {
        self.hidden = YES;
        return;
    }
    self.model = model;
    self.backgroundColor = magicColor;
    self.magicColor = magicColor;
    [self.castCollection reloadData];
    __block NSString *director = @"Unknown";
    [model.crew enumerateObjectsUsingBlock:^(GZECrewItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.job isEqualToString:@"Director"]) {
            director = obj.name;
            *stop = YES;
        }
    }];
    self.directorLabel.text = [NSString stringWithFormat:@"Director: %@", director];
}

- (CGSize)itemSize
{
    CGFloat width = (int)(SCREEN_WIDTH / kCastCount);
    CGFloat height = width * 1.5 + 70.f;
    return CGSizeMake(width, height);
}

- (void)setupSubviews
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.castCollection];
    [self addSubview:self.directorLabel];
    [self addSubview:self.seeAllBtn];
    [self.seeAllBtn addSubview:self.rightIcon];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10.f);
        make.leading.equalTo(self).offset(15.f);
        make.trailing.equalTo(self).offset(-15.f);
    }];
    [self.castCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo([self itemSize].height);
        make.leading.equalTo(self).offset(15.f);
        make.trailing.equalTo(self);
    }];
    [self.directorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.castCollection.mas_bottom).offset(10.f);
        make.leading.trailing.equalTo(self.titleLabel);
    }];
    [self.seeAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.directorLabel.mas_bottom).offset(10.f);
        make.leading.trailing.equalTo(self.titleLabel);
        make.bottom.equalTo(self).offset(-10.f);
    }];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14.f, 14.f));
        make.trailing.centerY.equalTo(self.seeAllBtn);
    }];
}

#pragma mark - UICollectionViewDelegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZECastSmallCell *cell = (GZECastSmallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZECastSmallCell class]) forIndexPath:indexPath];
    GZECastItem *cast = self.model.cast[indexPath.row];
    [cell updateWithModel:cast magicColor:self.magicColor];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.cast.count > 10 ? 10 : self.model.cast.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZECastItem *model = self.model.cast[indexPath.row];
    !self.didTapPeople ?: self.didTapPeople(model.identifier);
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16.f);
        _titleLabel.text = @"Cast & Crew";
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UICollectionView *)castCollection
{
    if (!_castCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = [self itemSize];
        layout.minimumLineSpacing = 15.f;
        
        _castCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _castCollection.showsHorizontalScrollIndicator = NO;
        _castCollection.delegate = self;
        _castCollection.dataSource = self;
        _castCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 15.f);
        _castCollection.backgroundColor = self.magicColor;
        [_castCollection registerClass:[GZECastSmallCell class] forCellWithReuseIdentifier:NSStringFromClass([GZECastSmallCell class])];
    }
    return _castCollection;
}

- (UILabel *)directorLabel
{
    if (!_directorLabel) {
        _directorLabel = [[UILabel alloc] init];
        _directorLabel.font = kFont(14.f);
        _directorLabel.textColor = [UIColor whiteColor];
    }
    return _directorLabel;
}

- (UIButton *)seeAllBtn
{
    if (!_seeAllBtn) {
        _seeAllBtn = [[UIButton alloc] init];
        _seeAllBtn.titleLabel.font = kFont(14.f);
        [_seeAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _seeAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_seeAllBtn setTitle:@"All cast & crew" forState:UIControlStateNormal];
        [_seeAllBtn addTarget:self action:@selector(didTapSeeAllBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeAllBtn;
}

- (UIImageView *)rightIcon
{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = kGetImage(@"arrow-right-white");
    }
    return _rightIcon;
}

#pragma mark - action
- (void)didTapSeeAllBtn
{
    
}

@end
