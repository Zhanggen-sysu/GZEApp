//
//  GZESearchVC.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import "GZESearchVC.h"
#import "Macro.h"
#import "Masonry.h"
#import "GZESearchTableViewCell.h"
#import <JXCategoryView/JXCategoryView.h>
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>
#import "GZESearchRsp.h"
#import "GZESearchReq.h"
#import "GZESearchCellViewModel.h"
#import "GZECommonHelper.h"

@interface GZESearchVC () <YPNavigationBarConfigureStyle, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GZETrendingViewModel *viewModel;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) JXCategoryTitleView *segmentView;
@property (nonatomic, strong) UITableView *searchTableView;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *recentTableView;
@property (nonatomic, strong) UITableView *trendTableView;

@property (nonatomic, strong) GZESearchReq *request;
@property (nonatomic, strong) NSMutableArray<GZESearchCellViewModel *> *searchArray;
@property (nonatomic, assign) NSInteger page;
 
@end

@implementation GZESearchVC

- (instancetype)initWithTrendingViewModel:(GZETrendingViewModel *)viewModel
{
    if (self = [super init]) {
        self.viewModel = viewModel;
        self.page = 0;
        self.request = [[GZESearchReq alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self defineLayout];
    self.navigationItem.titleView = self.searchView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancel)];
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = RGBColor(245, 245, 245);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - Network
- (void)loadDataWithMore:(BOOL)loadMore
{
    if (self.searchBar.text.length <= 0) {
        return;
    }
    // 停掉上一个请求
    [self.request stop];
    
    self.page = loadMore ? ++self.page : 1;
    self.request.page = @(self.page);
    self.request.query = self.searchBar.text;
    WeakSelf(self)
    [self.request startRequestWithRspClass:[GZESearchRsp class]
                             completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
        StrongSelfReturnNil(self)
        if (isSuccess) {
            GZESearchRsp *response = (GZESearchRsp *)rsp;
            if (loadMore) {
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                NSInteger cnt = self.searchArray.count;
                [response.results enumerateObjectsUsingBlock:^(GZESearchListItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:cnt+idx inSection:3]];
                    [self.searchArray addObject:[GZESearchCellViewModel viewModelWithSearchModel:obj]];
                }];
                [self.searchTableView beginUpdates];
                [self.searchTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [self.searchTableView endUpdates];
            } else {
                self.searchArray = [[NSMutableArray alloc] init];
                [response.results enumerateObjectsUsingBlock:^(GZESearchListItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.searchArray addObject:[GZESearchCellViewModel viewModelWithSearchModel:obj]];
                }];
                [self.searchTableView reloadData];
            }
        } else {
            [GZECommonHelper showMessage:errorMessage inView:self.view duration:1.5];
        }
    }];
}

#pragma mark - Action
- (void)didTapCancel
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UI
- (void)setupSubviews
{
    [self.searchView addSubview:self.searchBar];
    [self.view addSubview:self.searchTableView];
    [self.view addSubview:self.containerView];
}

- (void)defineLayout
{
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 导航栏+过滤按钮高度
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view).offset(44);
        }
        make.bottom.left.right.equalTo(self.view);
    }];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-90, 36)];
        _searchBar.placeholder = @"Search Movie, TV, Person...";
        _searchBar.searchTextField.font = kFont(14);
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.cornerRadius = 10.f;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-90, 36)];
    }
    return _searchView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UITableView *)searchTableView
{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _searchTableView.rowHeight = 75;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchTableView.showsVerticalScrollIndicator = NO;
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
    }
    return _searchTableView;
}

#pragma mark - UITableViewDelegate, DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZESearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GZESearchTableViewCell class])];
    if (!cell) {
        cell = [[GZESearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GZESearchTableViewCell class])];
    }
    GZESearchCellViewModel *viewModel = self.searchArray[indexPath.row];
    [cell updateWithModel:viewModel];
    return cell;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        self.containerView.hidden = YES;
        self.searchTableView.hidden = NO;
        [self loadDataWithMore:NO];
    } else {
        self.containerView.hidden = NO;
        self.searchTableView.hidden = YES;
    }
}

#pragma mark - YPNavigationBarConfigureStyle
- (YPNavigationBarConfigurations)yp_navigtionBarConfiguration {
    return YPNavigationBarShow | YPNavigationBarBackgroundStyleOpaque | YPNavigationBarBackgroundStyleColor;
}

- (UIColor *)yp_navigationBarTintColor {
    return [UIColor blackColor];
}

- (UIColor *)yp_navigationBackgroundColor {
    return [UIColor whiteColor];
}

@end
