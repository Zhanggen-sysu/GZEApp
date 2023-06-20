//
//  GZEFilterTableViewCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/5/30.
//

#import "GZEFilterTableViewCell.h"
#import "GZEFilterViewModel.h"
#import "GZEDiscoverFilterCell.h"
#import "NSString+GZEExtension.h"

@interface GZEFilterTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GZEFilterModel *model;

@end

@implementation GZEFilterTableViewCell

- (void)setupSubviews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.collectionView];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView).offset(10.f);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.leading.equalTo(self.contentView).offset(10.f);
        make.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10.f);
        make.height.mas_equalTo(30.f);
    }];
}

- (void)updateWithModel:(GZEFilterModel *)model
{
    self.model = model;
    self.titleLabel.text = model.title;
    self.collectionView.allowsMultipleSelection = model.allowMultiSelect;
    [self.collectionView reloadData];
    if (self.model.selectIndexs.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.model.selectIndexs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSNumber *selectIndex = (NSNumber *)obj;
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex.integerValue inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }];
        });
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16);
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 10);
        [_collectionView registerClass:[GZEDiscoverFilterCell class] forCellWithReuseIdentifier:NSStringFromClass([GZEDiscoverFilterCell class])];
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZEDiscoverFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GZEDiscoverFilterCell class]) forIndexPath:indexPath];
    GZEFilterItem *model = self.model.array[indexPath.row];
    [cell updateWithString:model.value];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.model.allowMultiSelect) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *selectIndexs = [collectionView indexPathsForSelectedItems];
        [selectIndexs enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:@(obj.row)];
        }];
        self.model.selectIndexs = array;
    } else {
        if (self.model.selectIndexs.count > 0) {
            NSNumber *selectIndex = (NSNumber *)self.model.selectIndexs.firstObject;
            if (selectIndex.integerValue == indexPath.row && self.model.filterType != GZEFilterType_MediaType) {
                GZEDiscoverFilterCell *cell = (GZEDiscoverFilterCell *)[collectionView cellForItemAtIndexPath:indexPath];
                [cell updateSelected:NO];
                [self.model.selectIndexs removeAllObjects];
            } else {
                self.model.selectIndexs = [[NSMutableArray alloc] initWithObjects:@(indexPath.row), nil];
            }
        } else {
            self.model.selectIndexs = [[NSMutableArray alloc] initWithObjects:@(indexPath.row), nil];
        }
    }
    if ([self.delegate respondsToSelector:@selector(filterCell:selectIndex:)]) {
        [self.delegate filterCell:self selectIndex:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.model.allowMultiSelect) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *selectIndexs = [collectionView indexPathsForSelectedItems];
        [selectIndexs enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:@(obj.row)];
        }];
        self.model.selectIndexs = array;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.model.array[indexPath.row].value;
    CGFloat width = [text widthWithHeight:30 font:kFont(15)] + 20;
    CGFloat height = 30;
    return CGSizeMake(width, height);
}


@end
