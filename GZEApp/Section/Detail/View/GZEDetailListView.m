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
#import "GZEGlobalConfig.h"
#import "GZECollectionViewBindingHelper.h"

@interface GZEDetailListView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *rightIcon;

@property (nonatomic, strong) GZECollectionViewBindingHelper *bindingHelper;

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
    RAC(self, backgroundColor) = RACObserve(viewModel, magicColor);
    RAC(self.collectionView, backgroundColor) = RACObserve(viewModel, magicColor);
    self.bindingHelper = [GZECollectionViewBindingHelper bindCollectionView:self.collectionView
                                                               sourceSignal:[RACObserve(viewModel, listArray) map:^id _Nullable(NSArray * _Nullable value) {
        return [value subarrayWithRange:NSMakeRange(0, MIN(value.count, 10))];
    }]
                                                              selectCommand:viewModel.movieCommand
                                                                  cellClass:[GZEDetailListCell class]];
    WeakSelf(self)
    [RACObserve(viewModel, listArray) subscribeNext:^(NSArray * _Nullable x) {
        StrongSelfReturnNil(self)
        if (x.count <= 0) {
            self.hidden = YES;
        } else if (x.count <= 10) {
            self.rightIcon.hidden = YES;
        }
    }];
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

- (CGSize)itemSize
{
    CGFloat width = 154;
    CGFloat height = (int)(width * 1.5) + 64;
    return CGSizeMake(width, height);
}

@end
