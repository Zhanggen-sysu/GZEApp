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
#import "GZESearchListView.h"
#import "GZESearchAdvanceView.h"
#import "GZETVDetailVC.h"
#import "GZEMovieDetailVC.h"
#import <MJRefresh/MJRefresh.h>
#import <JXCategoryView/JXCategoryView.h>
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>
#import "GZESearchRsp.h"
#import "GZESearchReq.h"
#import "GZESearchCellViewModel.h"
#import "GZETrendingViewModel.h"
#import "GZECommonHelper.h"

static NSString *kRecentSearchKey = @"kRecentSearchKey";
static NSInteger kRecentSearchMax = 20;

@interface GZESearchVC () <YPNavigationBarConfigureStyle, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, JXCategoryListContainerViewDelegate, GZESearchListViewDelegate>

@property (nonatomic, strong) GZETrendingViewModel *viewModel;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) JXCategoryTitleView *segmentView;
@property (nonatomic, strong) UITableView *searchTableView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) JXCategoryListContainerView *containerView;
@property (nonatomic, strong) GZESearchListView *recentView;
@property (nonatomic, strong) GZESearchListView *trendView;
@property (nonatomic, strong) GZESearchAdvanceView *advanceView;

@property (nonatomic, strong) GZESearchReq *request;
@property (nonatomic, strong) NSMutableArray<GZESearchCellViewModel *> *searchArray;
@property (nonatomic, strong) NSMutableArray<GZESearchCellViewModel *> *recentArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger selectIndex;
 
@end

@implementation GZESearchVC

- (instancetype)initWithTrendingViewModel:(GZETrendingViewModel *)viewModel
{
    if (self = [super init]) {
        self.viewModel = viewModel;
        self.page = 0;
        self.selectIndex = 0;
        self.request = [[GZESearchReq alloc] init];
        self.recentArray = [[NSMutableArray alloc] init];
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
                    [indexPaths addObject:[NSIndexPath indexPathForRow:cnt+idx inSection:0]];
                    [self.searchArray addObject:[GZESearchCellViewModel viewModelWithSearchModel:obj]];
                }];
                [self.searchTableView beginUpdates];
                [self.searchTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [self.searchTableView endUpdates];
                [self.searchTableView.mj_footer endRefreshing];
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

- (void)didSelectCell:(GZESearchCellViewModel *)viewModel
{
    if (![self.recentArray containsObject:viewModel]) {
        [self.recentArray insertObject:viewModel atIndex:0];
        if (self.recentArray.count > kRecentSearchMax) {
            [self.recentArray removeLastObject];
        }
        [self.recentView updateWithModel:self.recentArray];
        [GZECommonHelper setModel:self.recentArray withKey:kRecentSearchKey];
    }
    if (viewModel.mediaType == GZEMediaType_Movie) {
        GZEMovieDetailVC *vc = [[GZEMovieDetailVC alloc] initWithMovieId:viewModel.ID];
        // tips: 下一页的返回按钮需要在上一页设置才有效
        self.navigationItem.backButtonTitle = @"";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (viewModel.mediaType == GZEMediaType_TV) {
        GZETVDetailVC *vc = [[GZETVDetailVC alloc] initWithTVId:viewModel.ID];
        // tips: 下一页的返回按钮需要在上一页设置才有效
        self.navigationItem.backButtonTitle = @"";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UI
- (void)setupSubviews
{
    [self.searchView addSubview:self.searchBar];
    [self.view addSubview:self.searchTableView];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.segmentView];
    [self.contentView addSubview:self.containerView];
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
        make.bottom.leading.trailing.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view).offset(44);
        }
        make.bottom.leading.trailing.equalTo(self.view);
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.top.equalTo(self.segmentView.mas_bottom).offset(10.f);
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

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (JXCategoryTitleView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[JXCategoryTitleView alloc] init];
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.titles = @[@"Trending", @"Recent", @"Advance Search"];
        _segmentView.titleFont = kBoldFont(14.f);
        _segmentView.titleColor = RGBColor(128, 128, 128);
        _segmentView.titleSelectedColor = [UIColor blackColor];
        _segmentView.cellWidth = SCREEN_WIDTH / 3;
        _segmentView.cellSpacing = 0;
        _segmentView.contentEdgeInsetLeft = 0;
        _segmentView.contentEdgeInsetRight = 0;
        _segmentView.averageCellSpacingEnabled = NO;
        _segmentView.listContainer = self.containerView;
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = RGBColor(0, 191, 255);
        lineView.indicatorWidth = SCREEN_WIDTH / 3;
        lineView.indicatorHeight = 2.0f;
        _segmentView.indicators = @[lineView];
    }
    return _segmentView;
}

- (JXCategoryListContainerView *)containerView
{
    if (!_containerView) {
        _containerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _containerView.scrollView.scrollEnabled = NO;
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
        WeakSelf(self)
        _searchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            StrongSelfReturnNil(self)
            [self loadDataWithMore:YES];
        }];
    }
    return _searchTableView;
}

- (GZESearchListView *)trendView
{
    if (!_trendView) {
        _trendView = [[GZESearchListView alloc] init];
        _trendView.delegate = self;
        WeakSelf(self)
        _trendView.selectItemBlock = ^(GZESearchCellViewModel * _Nonnull model) {
            StrongSelfReturnNil(self)
            [self didSelectCell:model];
        };
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self.viewModel.media enumerateObjectsUsingBlock:^(GZETrendingItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:[GZESearchCellViewModel viewModelWithTrendModel:obj]];
        }];
        [self.viewModel.people enumerateObjectsUsingBlock:^(GZETrendingItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:[GZESearchCellViewModel viewModelWithTrendModel:obj]];
        }];
        [_trendView updateWithModel:array];
    }
    return _trendView;
}

- (GZESearchListView *)recentView
{
    if (!_recentView) {
        _recentView = [[GZESearchListView alloc] init];
        _recentView.supportDelete = YES;
        _recentView.delegate = self;
        WeakSelf(self)
        _recentView.selectItemBlock = ^(GZESearchCellViewModel * _Nonnull model) {
            StrongSelfReturnNil(self)
            [self didSelectCell:model];
        };
        _recentView.deleteItemBlock = ^(NSMutableArray<GZESearchCellViewModel *> * _Nonnull model) {
            StrongSelfReturnNil(self)
            self.recentArray = model;
            [GZECommonHelper setModel:self.recentArray withKey:kRecentSearchKey];
        };
        NSArray *array = [GZECommonHelper getModel:[GZESearchCellViewModel class] withKey:kRecentSearchKey dataType:GZEDataType_array];
        [self.recentArray addObjectsFromArray:array];
        [_recentView updateWithModel:self.recentArray];
    }
    return _recentView;
}

- (GZESearchAdvanceView *)advanceView
{
    if (!_advanceView) {
        _advanceView = [[GZESearchAdvanceView alloc] init];
    }
    return _advanceView;
}

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView
{
    return 3;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index
{
    if (index == 0) {
        return self.trendView;
    } else if (index == 1) {
        return self.recentView;
    }
    return self.advanceView;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZESearchCellViewModel *viewModel = self.searchArray[indexPath.row];
    [self didSelectCell:viewModel];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.segmentView.selectedIndex != 2) {
        if (searchText.length > 0) {
            self.contentView.hidden = YES;
            self.searchTableView.hidden = NO;
            [self loadDataWithMore:NO];
        } else {
            self.contentView.hidden = NO;
            self.searchTableView.hidden = YES;
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.segmentView.selectedIndex == 2)
    {
        
    }
}

#pragma mark - GZESearchListViewDelegate
- (void)GZESearchListViewDidScroll:(GZESearchListView *)listView
{
    [self.searchBar resignFirstResponder];
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
