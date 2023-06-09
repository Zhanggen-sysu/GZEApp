//
//  GZESearchListView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZESearchListView.h"
#import "GZESearchCellViewModel.h"
#import "GZESearchTableViewCell.h"

@interface GZESearchListView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray<GZESearchCellViewModel *> *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GZESearchListView

- (UIView *)listView
{
    return self;
}

- (void)updateWithModel:(NSMutableArray *)model
{
    self.viewModel = model;
    [self.tableView reloadData];
}

- (void)setupSubviews
{
    [self addSubview:self.tableView];
}

- (void)defineLayout
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 75;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
    return self.viewModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZESearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GZESearchTableViewCell class])];
    if (!cell) {
        cell = [[GZESearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GZESearchTableViewCell class])];
    }
    GZESearchCellViewModel *viewModel = self.viewModel[indexPath.row];
    [cell updateWithModel:viewModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZESearchCellViewModel *viewModel = self.viewModel[indexPath.row];
    !self.selectItemBlock ?: self.selectItemBlock(viewModel);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.supportDelete;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row < self.viewModel.count) {
            [self.viewModel removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            !self.deleteItemBlock ?: self.deleteItemBlock(self.viewModel);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(GZESearchListViewDidScroll:)]) {
        [self.delegate GZESearchListViewDidScroll:self];
    }
}

@end
