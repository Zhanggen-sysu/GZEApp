//
//  GZEDiscoverSortView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/16.
//

#import "GZEDiscoverSortView.h"
#import "GZEDiscoverSortCell.h"
#import "GZEGenreItem.h"

@interface GZEDiscoverSortView () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy) NSArray<GZEGenreItem *> *model;
@property (nonatomic, assign) GZEMediaType mediaType;

@end

@implementation GZEDiscoverSortView

#pragma mark - Public
- (void)updateWithModel:(NSArray<GZEGenreItem *> *)model mediaType:(GZEMediaType)mediaType
{
    if (self.mediaType != mediaType) {
        self.mediaType = mediaType;
        self.model = model;
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)show
{
    self.hidden = NO;
    [self.bgView.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.model.count * 30);
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

#pragma mark - private
- (void)tapBgView
{
    !self.dismissBlock ?: self.dismissBlock();
}

- (void)setupSubviews
{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
}

- (void)defineLayout
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.bgView);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(210);
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
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    return _contentView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 30.f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate, DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZEDiscoverSortCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GZEDiscoverSortCell class])];
    if (!cell) {
        cell = [[GZEDiscoverSortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GZEDiscoverSortCell class])];
    }
    [cell updateWithTitle:self.model[indexPath.row].name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    !self.selectItemBlock ?: self.selectItemBlock(indexPath.row);
    [self dismiss];
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
