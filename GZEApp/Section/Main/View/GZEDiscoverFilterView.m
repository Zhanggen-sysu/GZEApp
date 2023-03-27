//
//  GZEDiscoverFilterView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/16.
//

#import "GZEDiscoverFilterView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "GZEDiscoverFilterCell.h"

@interface GZEDiscoverFilterView () <UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) GZEDiscoverFilterViewModel *viewModel;

@end

@implementation GZEDiscoverFilterView

#pragma mark - Public
- (void)updateWithModel:(GZEDiscoverFilterViewModel *)viewModel
{
    if (viewModel.mediaType != self.viewModel.mediaType || viewModel.filterType != self.viewModel.filterType) {
        self.viewModel = viewModel;
        [self.collectionView reloadData];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:viewModel.selectIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)show
{
    self.hidden = NO;
    [self.bgView.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40 * (self.viewModel.itemArray.count / 3 + (self.viewModel.itemArray.count % 3 ? 1 : 0)) + 10);
        }];
        [self.contentView.superview layoutIfNeeded];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.contentView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - Action
- (void)tapBgView
{
    !self.dismissBlock ?: self.dismissBlock(self.viewModel.filterType);
}

#pragma mark - UI
- (void)setupSubviews
{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];
}

- (void)defineLayout
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.bgView);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(500);
        make.leading.trailing.top.equalTo(self.contentView);
    }];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
        ges.delegate = self;
        _bgView.userInteractionEnabled = YES;
        [_bgView addGestureRecognizer:ges];
    }
    return _bgView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]  init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    return _contentView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 20;
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 60) / 3.f, 30);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [_collectionView registerClass:[GZEDiscoverFilterCell class] forCellWithReuseIdentifier:NSStringFromClass([GZEDiscoverFilterCell class])];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate, DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.itemArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZEDiscoverFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZEDiscoverFilterCell class]) forIndexPath:indexPath];
    NSString *text = self.viewModel.itemArray[indexPath.row].value;
    [cell updateWithString:text];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    !self.selectItemBlock ?: self.selectItemBlock(self.viewModel.itemArray[indexPath.row], self.viewModel.filterType, indexPath.row);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.contentView.frame, point)) {
        return NO;
    }
    return YES;
}


@end
