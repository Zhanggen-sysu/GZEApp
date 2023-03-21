//
//  GZEListCollectionViewCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEListCollectionViewCell.h"
#import "GZEListCollectionViewModel.h"
#import "GZEListSmallTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GZECommonHelper.h"

@interface GZEListCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GZEListCollectionViewModel *viewModel;

@end

@implementation GZEListCollectionViewCell

- (void)updateWithModel:(GZEListCollectionViewModel *)viewModel
{
    self.viewModel = viewModel;
    self.titleLabel.text = viewModel.title;
    [self.bgImg sd_setImageWithURL:viewModel.imgUrl placeholderImage:kGetImage(@"default-backdrop")];
    [self.tableView reloadData];
}

- (void)setupSubviews
{
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 15.f;
    [self.contentView addSubview:self.bgImg];
    [self.contentView addSubview:self.maskView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tableView];
}

- (void)defineLayout
{
    // 320*180
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(180.f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15.f);
        make.right.equalTo(self.contentView).offset(-15.f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15.f);
        make.height.mas_equalTo(240);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self layoutIfNeeded];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.maskView.bounds;
    gradientLayer.colors = @[(__bridge id)RGBAColor(70, 130, 180, 0.1f).CGColor
                             , (__bridge id)RGBAColor(70, 130, 180, 1.f).CGColor
                             , (__bridge id)RGBAColor(70, 130, 180, 1.f).CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0, @0.4, @1];
    [self.maskView.layer addSublayer:gradientLayer];
}

- (UIImageView *)bgImg {
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
    }
    return _bgImg;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16.f);
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
    }
    return _maskView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 80.f;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate, DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZEListSmallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GZEListSmallTableViewCell class])];
    if (!cell) {
        cell = [[GZEListSmallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GZEListSmallTableViewCell class])];
    }
    GZEListSmallTableViewCellModel *model = self.viewModel.viewModels[indexPath.row];
    [cell updateWithIndex:indexPath.row+1 model:model];
    return cell;
}


@end
