//
//  GZESearchResultVC.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/12.
//

#import "GZESearchResultVC.h"
#import "Masonry.h"
#import <TTGTextTagCollectionView.h>

@interface GZESearchResultVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TTGTextTagCollectionView *filterView;

@end

@implementation GZESearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupSubviews
{
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.tableView];
}

- (void)defineLayout
{
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view).offset(44);
        }
        make.leading.trailing.equalTo(self.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
