//
//  GZEFilterAdvanceView.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEFilterAdvanceView.h"
#import "GZEFilterTableViewCell.h"

@interface GZEFilterAdvanceView () <UITableViewDataSource, UITableViewDelegate, GZEFilterTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) GZEFilterViewModel *viewModel;
@property (nonatomic, assign) GZEMediaType currentMediaType;

@end

@implementation GZEFilterAdvanceView

- (instancetype)initWithFilterType:(GZEFilterType)filterType
{
    if (self = [super initWithFrame:CGRectZero]) {
        [GZEFilterViewModel createFilterModelWithType:filterType completeBlock:^(GZEFilterViewModel * _Nonnull viewModel) {
            self.viewModel = viewModel;
            self.currentMediaType = GZEMediaType_Movie;
            [self.tableView reloadData];
        }];
    }
    return self;
}

- (NSIndexPath *)p_indexPathForFilterType:(GZEFilterType)filterType
{
    __block NSIndexPath *ret = nil;
    [self.viewModel.filterArray enumerateObjectsUsingBlock:^(GZEFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.filterType == filterType) {
            ret = [NSIndexPath indexPathForRow:idx inSection:0];
            *stop = YES;
        }
    }];
    return ret;
}

#pragma mark - UI
- (void)setupSubviews
{
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.confirmBtn];
    [self.bottomView addSubview:self.clearBtn];
}

- (void)defineLayout
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-50);
        } else {
            make.top.equalTo(self.mas_bottom).offset(-50.f);
        }
    }];
    
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.leading.equalTo(self).offset(20.f);
        make.width.equalTo(self.confirmBtn);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.clearBtn.mas_trailing).offset(30.f);
        make.trailing.equalTo(self).offset(-20.f);
        make.bottom.height.equalTo(self.clearBtn);
    }];
}

- (void)didTapClearBtn
{
    [self.viewModel.filterArray enumerateObjectsUsingBlock:^(GZEFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.filterType == GZEFilterType_MediaType) {
            obj.selectIndexs = [[NSMutableArray alloc] initWithObjects:@0, nil];
        } else {
            obj.selectIndexs = [NSMutableArray new];
        }
    }];
    [self.tableView reloadData];
}

- (void)didTapConfirmBtn
{
    if ([self.delegate respondsToSelector:@selector(filterAdvanceView:viewModel:)]) {
        [self.delegate filterAdvanceView:self viewModel:self.viewModel];
    }
}

#pragma mark - LazyLoad

- (UIButton *)clearBtn
{
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] init];
        [_clearBtn setTitle:@"Clear" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:RGBColor(0, 191, 255) forState:UIControlStateNormal];
        _clearBtn.backgroundColor = [UIColor whiteColor];
        _clearBtn.layer.borderWidth = 1;
        _clearBtn.layer.borderColor = RGBColor(0, 191, 255).CGColor;
        _clearBtn.titleLabel.font = kBoldFont(14.f);
        _clearBtn.layer.masksToBounds = YES;
        _clearBtn.layer.cornerRadius = 10.f;
        [_clearBtn addTarget:self action:@selector(didTapClearBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"Confirm" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = RGBColor(0, 191, 255);
        _confirmBtn.titleLabel.font = kBoldFont(14.f);
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 10.f;
        [_confirmBtn addTarget:self action:@selector(didTapConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[GZEFilterTableViewCell class] forCellReuseIdentifier:NSStringFromClass([GZEFilterTableViewCell class])];
    }
    return _tableView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

#pragma mark - UITableViewDelegate, DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZEFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GZEFilterTableViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    GZEFilterModel *model = self.viewModel.filterArray[indexPath.row];
    [cell updateWithModel:model];
    return cell;
}

#pragma mark - GZEFilterTableViewCellDelegate
- (void)filterCell:(GZEFilterTableViewCell *)cell selectIndex:(NSInteger)index
{
    if (cell.model.filterType == GZEFilterType_MediaType) {
        GZEFilterItem *item = cell.model.array[index];
        GZEMediaType mediaType = self.currentMediaType;
        if ([item.key isEqualToString:@"tv"]) {
            mediaType = GZEMediaType_TV;
        } else if ([item.key isEqualToString:@"movie"]) {
            mediaType = GZEMediaType_Movie;
        }
        if (self.currentMediaType == mediaType) {
            return;
        }
        self.currentMediaType = mediaType;
        [self.viewModel selectMediaType:mediaType completeBlock:^{
            NSIndexPath *indexPath = [self p_indexPathForFilterType:GZEFilterType_Genre];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }];
    } else if (cell.model.filterType == GZEFilterType_Year) {
        NSIndexPath *indexPath = [self p_indexPathForFilterType:GZEFilterType_Decade];
        GZEFilterModel* model = self.viewModel.filterArray[indexPath.row];
        model.selectIndexs = [NSMutableArray new];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else if (cell.model.filterType == GZEFilterType_Decade) {
        NSIndexPath *indexPath = [self p_indexPathForFilterType:GZEFilterType_Year];
        GZEFilterModel* model = self.viewModel.filterArray[indexPath.row];
        model.selectIndexs = [NSMutableArray new];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
