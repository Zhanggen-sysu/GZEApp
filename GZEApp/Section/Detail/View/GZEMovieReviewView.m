//
//  GZEMovieReviewView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/30.
//

#import "GZEMovieReviewView.h"
#import "GZECustomButton.h"
#import "GZEMovieReviewRsp.h"
#import "GZEReviewCell.h"
#import "GZECommonHelper.h"
#import "GZEReviewItem.h"

@interface GZEMovieReviewView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GZECustomButton *seeAllBtn;

@property (nonatomic, strong) GZEMovieReviewRsp *model;
@property (nonatomic, strong) UIColor *magicColor;

@end

@implementation GZEMovieReviewView

- (void)updateWithModel:(GZEMovieReviewRsp *)model magicColor:(nonnull UIColor *)magicColor
{
    if (model.results.count <= 0) {
        self.hidden = YES;
        return;
    }
    self.backgroundColor = magicColor;
    self.tableView.backgroundColor = magicColor;
    self.magicColor = magicColor;
    self.model = model;
    [self.tableView reloadData];
    [self resetTableViewHeight];
    if (self.model.results.count > 3) {
        [self.seeAllBtn setTitle:[NSString stringWithFormat:@"See All (%ld)", self.model.results.count] forState:UIControlStateNormal];
    } else {
        self.seeAllBtn.hidden = YES;
    }
}

- (void)resetTableViewHeight
{
    CGFloat height = 0;
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i ++) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        height += cell.bounds.size.height;
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)didTapSeeAll
{
    
}

- (void)setupSubviews
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.tableView];
    [self addSubview:self.seeAllBtn];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(15.f);
    }];
    [self.seeAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15.f);
        make.top.equalTo(self).offset(15.f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.leading.equalTo(self).offset(15.f);
        make.trailing.equalTo(self).offset(-15.f);
        make.bottom.equalTo(self).offset(-10);
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(420.f);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16.f);
        _titleLabel.text = @"Reviews";
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (GZECustomButton *)seeAllBtn
{
    if (!_seeAllBtn) {
        _seeAllBtn = [[GZECustomButton alloc] init];
        _seeAllBtn.titleLabel.font = kFont(14.f);
        [_seeAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_seeAllBtn setImage:kGetImage(@"arrow-right-white") forState:UIControlStateNormal];
        [_seeAllBtn setImagePosition:GZEBtnImgPosition_Right spacing:5 contentAlign:GZEBtnContentAlign_Right contentOffset:0 imageSize:CGSizeZero titleSize:CGSizeZero];
        [_seeAllBtn addTarget:self action:@selector(didTapSeeAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeAllBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return self.model.results.count > 3 ? 3 : self.model.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZEReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GZEReviewCell class])];
    if (!cell) {
        cell = [[GZEReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GZEReviewCell class])];
        WeakSelf(self)
        cell.didChangeHeight = ^(BOOL isExpand) {
            StrongSelfReturnNil(self)
            // 更新该行的高度
            self.model.results[indexPath.row].isExpand = isExpand;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self resetTableViewHeight];
        };
    }
    GZEReviewItem *item = self.model.results[indexPath.row];
    [cell updateWithModel:item magicColor:self.magicColor];
    return cell;
}

@end
