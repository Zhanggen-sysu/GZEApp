//
//  GZEDetailListView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEDetailListView.h"
#import "GZEDetailListCell.h"
#import "GZEPeopleCreditCell.h"
#import "GZEMovieListRsp.h"
#import "GZETVListRsp.h"
#import "GZECombinedCreditsRsp.h"
#import "GZEMediaCast.h"
#import "GZEMediaCrew.h"
#import "GZETVListItem.h"
#import "GZEMovieListItem.h"

@interface GZEDetailListView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *rightIcon;

@property (nonatomic, strong) GZEMovieListRsp *model;
@property (nonatomic, strong) GZETVListRsp *tvModel;
@property (nonatomic, strong) GZECombinedCreditsRsp *peopleModel;
@property (nonatomic, strong) UIColor *magicColor;

@end

@implementation GZEDetailListView

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.titleLabel.text = title;
    }
    return self;
}

- (void)updateWithCombinedCreditModel:(GZECombinedCreditsRsp *)model
{
    if (model.crew.count <= 0 && model.cast.count <= 0) {
        self.hidden = YES;
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor blackColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.rightIcon.image = kGetImage(@"arrow-right-gray");
    self.peopleModel = model;
    [self.collectionView reloadData];
    if (model.crew.count + model.cast.count <= 10) {
        self.rightIcon.hidden = YES;
    }
}

- (void)updateWithModel:(GZEMovieListRsp *)model magicColor:(nonnull UIColor *)magicColor
{
    if (model.results.count <= 0) {
        self.hidden = YES;
        return;
    }
    self.magicColor = magicColor;
    self.backgroundColor = magicColor;
    self.collectionView.backgroundColor = magicColor;
    self.model = model;
    [self.collectionView reloadData];
    if (model.results.count <= 10) {
        self.rightIcon.hidden = YES;
    }
}

- (void)updateWithTVModel:(GZETVListRsp *)model magicColor:(nonnull UIColor *)magicColor
{
    if (model.results.count <= 0) {
        self.hidden = YES;
        return;
    }
    self.magicColor = magicColor;
    self.backgroundColor = magicColor;
    self.collectionView.backgroundColor = magicColor;
    self.tvModel = model;
    [self.collectionView reloadData];
    if (model.results.count <= 10) {
        self.rightIcon.hidden = YES;
    }
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
        [_collectionView registerClass:[GZEPeopleCreditCell class] forCellWithReuseIdentifier:NSStringFromClass([GZEPeopleCreditCell class])];
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
    if (self.tvModel) {
        GZEDetailListCell *cell = (GZEDetailListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZEDetailListCell class]) forIndexPath:indexPath];
        GZETVListItem *result = self.tvModel.results[indexPath.row];
        [cell updateWithTVModel:result magicColor:self.magicColor];
        return cell;
    }
    if (self.model) {
        GZEDetailListCell *cell = (GZEDetailListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZEDetailListCell class]) forIndexPath:indexPath];
        GZEMovieListItem *result = self.model.results[indexPath.row];
        [cell updateWithModel:result magicColor:self.magicColor];
        return cell;
    }
    if (self.peopleModel) {
        GZEPeopleCreditCell *cell = (GZEPeopleCreditCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZEPeopleCreditCell class]) forIndexPath:indexPath];
        if (indexPath.row < self.peopleModel.cast.count) {
            GZEMediaCast *cast = self.peopleModel.cast[indexPath.row];
            [cell updateWithCastModel:cast];
        } else {
            GZEMediaCrew *crew = self.peopleModel.crew[indexPath.row - self.peopleModel.cast.count];
            [cell updateWithCrewModel:crew];
        }
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tvModel) {
        GZETVListItem *result = self.tvModel.results[indexPath.row];
        !self.didTapTv ?: self.didTapTv(result.identifier);
        return;
    }
    if (self.model) {
        GZEMovieListItem *result = self.model.results[indexPath.row];
        !self.didTapMovie ?: self.didTapMovie(result.identifier);
        return;
    }
    if (self.peopleModel) {
        if (indexPath.row < self.peopleModel.cast.count) {
            GZEMediaCast *cast = self.peopleModel.cast[indexPath.row];
            if ([cast.mediaType isEqualToString:@"tv"]) {
                !self.didTapTv ?: self.didTapTv(cast.identifier);
            } else if ([cast.mediaType isEqualToString:@"movie"]) {
                !self.didTapMovie ?: self.didTapMovie(cast.identifier);
            }
        } else {
            GZEMediaCrew *crew = self.peopleModel.crew[indexPath.row - self.peopleModel.cast.count];
            if ([crew.mediaType isEqualToString:@"tv"]) {
                !self.didTapTv ?: self.didTapTv(crew.identifier);
            } else if ([crew.mediaType isEqualToString:@"movie"]) {
                !self.didTapMovie ?: self.didTapMovie(crew.identifier);
            }
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.tvModel) {
        return self.tvModel.results.count > 10 ? 10 : self.tvModel.results.count;
    }
    if (self.peopleModel) {
        return self.peopleModel.cast.count + self.peopleModel.crew.count > 10 ? 10 : self.peopleModel.cast.count + self.peopleModel.crew.count;
    }
    return self.model.results.count > 10 ? 10 : self.model.results.count;
}

- (CGSize)itemSize
{
    CGFloat width = 154;
    CGFloat height = (int)(width * 1.5) + 64;
    return CGSizeMake(width, height);
}

@end
