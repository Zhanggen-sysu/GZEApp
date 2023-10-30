//
//  GZEListCollectionViewCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEListCollectionViewCell.h"
#import "GZEListCollectionViewModel.h"
#import "GZEListSmallTableViewCell.h"
#import "SDWebImageDownloader.h"
#import "GZECommonHelper.h"
#import "UIImage+magicColor.h"

@interface GZEListCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) GZEListCollectionViewModel *viewModel;

@end

@implementation GZEListCollectionViewCell

- (void)updateWithModel:(GZEListCollectionViewModel *)viewModel
{
    self.viewModel = viewModel;
    self.titleLabel.text = viewModel.title;
    WeakSelf(self)
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:viewModel.imgUrl completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        StrongSelfReturnNil(self)
        if (image) {
            self.bgImg.image = image;
            UIColor *magicColor = [image magicColor];
            self.gradientLayer.colors = @[(__bridge id)[magicColor colorWithAlphaComponent:0.1f].CGColor
                                          , (__bridge id)magicColor.CGColor
                                          , (__bridge id)magicColor.CGColor];
        } else {
            self.bgImg.image = kGetImage(@"default-backdrop");
            self.gradientLayer.colors = @[(__bridge id)RGBAColor(70, 130, 180, 0.1f).CGColor
                                          , (__bridge id)RGBAColor(70, 130, 180, 1.f).CGColor
                                          , (__bridge id)RGBAColor(70, 130, 180, 1.f).CGColor];
        }
    }];
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
    [self.maskView.layer addSublayer:self.gradientLayer];
}

- (void)defineLayout
{
    // 320*180
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.contentView);
        make.height.mas_equalTo(180.f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.contentView).offset(15.f);
        make.trailing.equalTo(self.contentView).offset(-15.f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15.f);
        make.height.mas_equalTo(240);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
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

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer  = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, 320, 300);
        _gradientLayer.startPoint = CGPointMake(0.5, 0);
        _gradientLayer.endPoint = CGPointMake(0.5, 1);
        _gradientLayer.locations = @[@0, @0.4, @1];
    }
    return _gradientLayer;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZEListSmallTableViewCellModel *model = self.viewModel.viewModels[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(listCollectionViewCellDidTapCell:)]) {
        [self.delegate listCollectionViewCellDidTapCell:model];
    }
}

@end
