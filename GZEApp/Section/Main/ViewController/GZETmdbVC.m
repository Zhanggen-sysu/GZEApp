//
//  GZETmdbVC.m
//  GZEApp
//
//  Created by GenZhang on 2023/2/28.
//

#import "GZETmdbVC.h"
#import "Masonry.h"
#import "Macro.h"
#import "MJRefresh.h"
#import "GZETmdbListManager.h"
#import "GZEGlobalConfig.h"
#import "GZEMovieListRsp.h"
#import "GZECompanyListRsp.h"
#import "GZECommonHelper.h"
#import "GZETrendingViewModel.h"
#import "GZEListCollectionViewModel.h"
#import "GZETrendingRsp.h"
#import "GZETVListRsp.h"
#import "GZEGenreItem.h"
#import "GZEDiscoverCellViewModel.h"
#import "GZEDiscoverFilterViewModel.h"

#import "GZEDiscoverFilterView.h"
#import "GZEDiscoverSortView.h"
#import "GZECustomButton.h"
#import "GZEDiscoverHeaderView.h"
#import "UIView+GZEExtension.h"
#import "GZETrendingCell.h"
#import "GZECompaniesCell.h"
#import "GZEListTableViewCell.h"
#import "GZEDiscoverCell.h"
#import "CYLTabBarController.h"
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>

@interface GZETmdbVC () <YPNavigationBarConfigureStyle, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) GZECustomButton *searchBtn;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GZETmdbListManager *manager;

@property (nonatomic, strong) GZETrendingViewModel *trendingModel;
@property (nonatomic, strong) NSMutableArray<GZEListCollectionViewModel *> *listViewModel;
@property (nonatomic, strong) NSMutableArray<GZEDiscoverCellViewModel *> *discoverArray;
@property (nonatomic, copy) NSArray *companyArray;
@property (nonatomic, assign) CGFloat gradientProgress;

@property (nonatomic, assign) GZEMediaType mediaType;
@property (nonatomic, strong) GZEMovieDiscoveryReq *moviesReq;
@property (nonatomic, strong) GZEMovieListRsp *moviesRsp;
@property (nonatomic, strong) GZETVDiscoveryReq *tvsReq;
@property (nonatomic, strong) GZETVListRsp *tvsRsp;

@property (nonatomic, copy) NSArray<GZEGenreItem *> *movieSortArray;
@property (nonatomic, copy) NSArray<GZEGenreItem *> *tvSortArray;
@property (nonatomic, strong) GZEDiscoverSortView *sortView;

@property (nonatomic, strong) GZEDiscoverFilterView *filterView;
@property (nonatomic, strong) GZEDiscoverFilterViewModel *movieGenreFilterModel;
@property (nonatomic, strong) GZEDiscoverFilterViewModel *tvGenreFilterModel;
@property (nonatomic, strong) GZEDiscoverFilterViewModel *movieLanguageFilterModel;
@property (nonatomic, strong) GZEDiscoverFilterViewModel *tvLanguageFilterModel;

@end

@implementation GZETmdbVC

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchBtn;
    
    [self setupSubviews];
    [self defineLayout];
    [self initData];
    [self loadData];
}

#pragma mark - StatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.gradientProgress < 0.5 ? UIStatusBarStyleLightContent : UIStatusBarStyleDarkContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

#pragma mark - Data
- (void)initData
{
    self.trendingModel = [[GZETrendingViewModel alloc] init];
    self.listViewModel = [NSMutableArray arrayWithObjects:
                          [GZEListCollectionViewModel new],
                          [GZEListCollectionViewModel new],
                          [GZEListCollectionViewModel new],
                          [GZEListCollectionViewModel new], nil];
    self.moviesReq = [[GZEMovieDiscoveryReq alloc] init];
    self.tvsReq = [[GZETVDiscoveryReq alloc] init];
    self.mediaType = GZEMediaType_Movie;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[GZEGenreItem itemWithId:GZEMovieDiscoverySortType_PopularityDesc name:@"Popularity"]];
    [array addObject:[GZEGenreItem itemWithId:GZEMovieDiscoverySortType_ReleaseDateDesc name:@"Release Date"]];
    [array addObject:[GZEGenreItem itemWithId:GZEMovieDiscoverySortType_RevenueDesc name:@"Revenue"]];
    [array addObject:[GZEGenreItem itemWithId:GZEMovieDiscoverySortType_OriginalTitleDesc name:@"Original Title"]];
    [array addObject:[GZEGenreItem itemWithId:GZEMovieDiscoverySortType_VoteAverageDesc name:@"Vote Average"]];
    [array addObject:[GZEGenreItem itemWithId:GZEMovieDiscoverySortType_VoteCountDesc name:@"Vote Count"]];
    self.movieSortArray = array;
    array = [[NSMutableArray alloc] init];
    [array addObject:[GZEGenreItem itemWithId:GZETVDiscoverySortType_PopularityDesc name:@"Popularity"]];
    [array addObject:[GZEGenreItem itemWithId:GZETVDiscoverySortType_VoteAverageDesc name:@"Vote Average"]];
    [array addObject:[GZEGenreItem itemWithId:GZETVDiscoverySortType_FirstAirDateDesc name:@"First Air Date"]];
    self.tvSortArray = array;
}

- (void)loadData
{
    WeakSelf(self)
    [self.manager getTrendingList:GZEMediaType_All timeWindow:GZETimeWindow_Week block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
        StrongSelfReturnNil(self)
        if (isSuccess) {
            GZETrendingRsp *model = (GZETrendingRsp *)rsp;
            [self.trendingModel setRsp:model];;
            [self.tableView reloadData];
        } else {
            [GZECommonHelper showMessage:errorMessage inView:self.view duration:1.5];
        }
    }];
    
    [self.manager getCompanyListType:GZECompanyListType_Movie block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
        StrongSelfReturnNil(self)
        if (isSuccess) {
            GZECompanyListRsp *model = (GZECompanyListRsp *)rsp;
            self.companyArray = model.results;
            [self.tableView reloadData];
        } else {
            [GZECommonHelper showMessage:errorMessage inView:self.view duration:1.5];
        }
    }];
    
    // 获取四个榜单信息，完成后同时刷新
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        WeakSelf(self)
        [self.manager getMovieListType:GZEMovieListType_Popular loadMore:NO block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieListRsp *model = (GZEMovieListRsp *)rsp;
                self.listViewModel[0] = [GZEListCollectionViewModel viewModelWithTitle:@"Popular Movie" movieList:model.results];
            }
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        WeakSelf(self)
        [self.manager getMovieListType:GZEMovieListType_TopRate loadMore:NO block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieListRsp *model = (GZEMovieListRsp *)rsp;
                self.listViewModel[1] = [GZEListCollectionViewModel viewModelWithTitle:@"Top Rated Movie" movieList:model.results];
            }
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        WeakSelf(self)
        [self.manager getTVListType:GZETVListType_Popular loadMore:NO block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZETVListRsp *model = (GZETVListRsp *)rsp;
                self.listViewModel[2] = [GZEListCollectionViewModel viewModelWithTitle:@"Popular TV" tvList:model.results];
            }
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        WeakSelf(self)
        [self.manager getTVListType:GZETVListType_TopRated loadMore:NO block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZETVListRsp *model = (GZETVListRsp *)rsp;
                self.listViewModel[3] = [GZEListCollectionViewModel viewModelWithTitle:@"Top Rated TV" tvList:model.results];
            }
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    dispatch_group_t newGroup = dispatch_group_create();
    dispatch_group_enter(newGroup);
    dispatch_async(queue, ^{
        // 需要先有类型配置，才能生成tableview的viewmodel
        WeakSelf(self)
        [[GZEGlobalConfig shareConfig] getGenresWithType:GZEMediaType_Movie completion:^(NSDictionary<NSNumber *,NSString *> * _Nonnull genres) {
            StrongSelfReturnNil(self)
            self.movieGenreFilterModel = [GZEDiscoverFilterViewModel viewModelWithGenreDict:genres mediaType:GZEMediaType_Movie];
            dispatch_group_leave(newGroup);
        }];
        [[GZEGlobalConfig shareConfig] getGenresWithType:GZEMediaType_TV completion:^(NSDictionary<NSNumber *,NSString *> * _Nonnull genres) {
            StrongSelfReturnNil(self)
            self.tvGenreFilterModel = [GZEDiscoverFilterViewModel viewModelWithGenreDict:genres mediaType:GZEMediaType_TV];
        }];
    });
    dispatch_group_enter(newGroup);
    dispatch_async(queue, ^{
        WeakSelf(self)
        [self.manager getMovieDiscoverWithReq:self.moviesReq loadMore:NO block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            if (isSuccess) {
                GZEMovieListRsp *response = (GZEMovieListRsp *)rsp;
                self.moviesRsp = response;
            }
            dispatch_group_leave(newGroup);
        }];
    });
    
    dispatch_group_notify(newGroup, dispatch_get_main_queue(), ^{
        [self updateTableView:NO];
    });
    
    [[GZEGlobalConfig shareConfig] getAllLanguagesWithCompletion:^(NSDictionary<NSString *,GZELanguageItem *> * _Nonnull allLanguage) {
        StrongSelfReturnNil(self)
        self.tvLanguageFilterModel = [GZEDiscoverFilterViewModel viewModelWithLanguageDict:allLanguage mediaType:GZEMediaType_TV];
        self.movieLanguageFilterModel = [GZEDiscoverFilterViewModel viewModelWithLanguageDict:allLanguage mediaType:GZEMediaType_Movie];
    }];
}

// 加载tableview discover列表数据
- (void)loadDataWithMore:(BOOL)loadMore
{
    if (self.mediaType == GZEMediaType_Movie) {
        WeakSelf(self)
        [self.manager getMovieDiscoverWithReq:self.moviesReq loadMore:loadMore block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            GZEMovieListRsp *response = (GZEMovieListRsp *)rsp;
            self.moviesRsp = response;
            [self updateTableView:loadMore];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }];
    } else if (self.mediaType == GZEMediaType_TV) {
        WeakSelf(self)
        [self.manager getTVDiscoverWithReq:self.tvsReq loadMore:loadMore block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            StrongSelfReturnNil(self)
            GZETVListRsp *response = (GZETVListRsp *)rsp;
            self.tvsRsp = response;
            [self updateTableView:loadMore];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }];
    }
}

- (GZETmdbListManager *)manager
{
    if (!_manager) {
        _manager = [[GZETmdbListManager alloc] init];
    }
    return _manager;
}

#pragma mark - private
// 统一这里调用dismiss 和 show
- (void)showOrHideSortView:(BOOL)isHidden
{
    GZEDiscoverHeaderView *header = (GZEDiscoverHeaderView *)[self.tableView headerViewForSection:3];
    if (isHidden) {
        [self.sortView dismiss];
        [header sortArrowIsUp:NO];
    } else {
        // 算上contentInset
        if (self.mediaType == GZEMediaType_TV) {
            [self.sortView updateWithModel:self.tvSortArray mediaType:self.mediaType];
        } else if (self.mediaType == GZEMediaType_Movie) {
            [self.sortView updateWithModel:self.movieSortArray mediaType:self.mediaType];
        }
        [header sortArrowIsUp:YES];
        
        CGFloat navigateBarHeight = self.navigationController.navigationBar.bottom - 49;
        if (self.tableView.contentOffset.y < header.top - navigateBarHeight) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.tableView setContentOffset:CGPointMake(0, header.top - navigateBarHeight) animated:NO];
            } completion:^(BOOL finished) {
                [self.sortView show];
            }];
        } else {
            [self.sortView show];
        }
    }
}

- (void)showOrHideFilterView:(BOOL)isHidden type:(GZEDiscoverFilterType)type
{
    GZEDiscoverHeaderView *header = (GZEDiscoverHeaderView *)[self.tableView headerViewForSection:3];
    if (isHidden) {
        [self.filterView dismiss];
        if (type == GZEDiscoverFilterType_Genre) {
            [header genreArrowIsUp:NO];
        } else if (type == GZEDiscoverFilterType_Language) {
            [header languageArrowIsUp:NO];
        }
    } else {
        if (type == GZEDiscoverFilterType_Genre) {
            [header genreArrowIsUp:YES];
            if (self.mediaType == GZEMediaType_TV) {
                [self.filterView updateWithModel:self.tvGenreFilterModel];
            } else if (self.mediaType == GZEMediaType_Movie) {
                [self.filterView updateWithModel:self.movieGenreFilterModel];
            }
        } else if (type == GZEDiscoverFilterType_Language) {
            [header languageArrowIsUp:YES];
            if (self.mediaType == GZEMediaType_TV) {
                [self.filterView updateWithModel:self.tvLanguageFilterModel];
            } else if (self.mediaType == GZEMediaType_Movie) {
                [self.filterView updateWithModel:self.movieLanguageFilterModel];
            }
        }
        CGFloat navigateBarHeight = self.navigationController.navigationBar.bottom - 49;
        if (self.tableView.contentOffset.y < header.top - navigateBarHeight) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.tableView setContentOffset:CGPointMake(0, header.top - navigateBarHeight) animated:NO];
            } completion:^(BOOL finished) {
                [self.filterView show];
            }];
        } else {
            [self.filterView show];
        }
    }
}

- (void)updateTableView:(BOOL)loadMore
{
    if (loadMore) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSInteger cnt = self.discoverArray.count;
        if (self.mediaType == GZEMediaType_Movie) {
            [self.moviesRsp.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:cnt+idx inSection:3]];
                [self.discoverArray addObject:[GZEDiscoverCellViewModel viewModelWithMovieItem:obj]];
            }];
            self.moviesRsp = nil;
        } else if (self.mediaType == GZEMediaType_TV) {
            [self.tvsRsp.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:cnt+idx inSection:3]];
                [self.discoverArray addObject:[GZEDiscoverCellViewModel viewModelWithTVItem:obj]];
            }];
            self.tvsRsp = nil;
        }
        // 局部刷新
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    } else {
        // 全局刷新
        self.discoverArray = [[NSMutableArray alloc] init];
        if (self.mediaType == GZEMediaType_Movie) {
            [self.moviesRsp.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.discoverArray addObject:[GZEDiscoverCellViewModel viewModelWithMovieItem:obj]];
            }];
            self.moviesRsp = nil;
        } else if (self.mediaType == GZEMediaType_TV) {
            [self.tvsRsp.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.discoverArray addObject:[GZEDiscoverCellViewModel viewModelWithTVItem:obj]];
            }];
            self.tvsRsp = nil;
        }
        [self.tableView reloadData];
    }
}

#pragma mark - UI
- (void)setupSubviews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.sortView];
    [self.view addSubview:self.filterView];
}

- (void)defineLayout
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view).offset(-self.cyl_tabBarController.tabBarHeight);
        }
        make.top.leading.trailing.equalTo(self.view);
    }];
    [self.sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        // 导航栏+过滤按钮高度
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(30.f);
        } else {
            make.top.equalTo(self.view).offset(44 + 30.f);
        }
    }];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        // 导航栏+过滤按钮高度
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(30.f);
        } else {
            make.top.equalTo(self.view).offset(44 + 30.f);
        }
    }];
}

- (GZECustomButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn = [[GZECustomButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 36)];
        [_searchBtn setImage:kGetImage(@"search-white") forState:UIControlStateNormal];
        [_searchBtn setTitle:@"Search Movie, TV, Person..." forState:UIControlStateNormal];
        _searchBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _searchBtn.titleLabel.font = kFont(14.f);
        _searchBtn.titleLabel.textColor = [UIColor whiteColor];
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.layer.cornerRadius = 18;
        _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_searchBtn setImagePosition:GZEBtnImgPosition_Left spacing:15 contentAlign:GZEBtnContentAlign_Left contentOffset:20 imageSize:CGSizeZero titleSize:CGSizeZero];
    }
    return _searchBtn;
}

- (GZEDiscoverSortView *)sortView
{
    if (!_sortView) {
        _sortView = [[GZEDiscoverSortView alloc] init];
        _sortView.hidden = YES;
        WeakSelf(self)
        _sortView.dismissBlock = ^{
            StrongSelfReturnNil(self)
            [self showOrHideSortView:YES];
        };
        _sortView.selectItemBlock = ^(NSInteger index) {
            StrongSelfReturnNil(self)
            GZEDiscoverHeaderView *header = (GZEDiscoverHeaderView *)[self.tableView headerViewForSection:3];
            GZEGenreItem *item = nil;
            if (self.mediaType == GZEMediaType_TV) {
                item = self.tvSortArray[index];
                self.tvsReq.sortType = item.identifier;
            } else if (self.mediaType == GZEMediaType_Movie) {
                item = self.movieSortArray[index];
                self.moviesReq.sortType = item.identifier;
            }
            // 先update再showOrhide
            [header updateSortTitle:item.name hightlight:index != 0];
            [self showOrHideSortView:YES];
            [self showOrHideFilterView:YES type:self.filterView.viewModel.filterType];
            [self loadDataWithMore:NO];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        };
    }
    return _sortView;
}

- (GZEDiscoverFilterView *)filterView
{
    if (!_filterView) {
        _filterView  = [[GZEDiscoverFilterView alloc] init];
        _filterView.hidden = YES;
        WeakSelf(self)
        _filterView.dismissBlock = ^(GZEDiscoverFilterType currentType) {
            StrongSelfReturnNil(self)
            [self showOrHideFilterView:YES type:currentType];
        };
        _filterView.selectItemBlock = ^(GZEDiscoverFilterItem * _Nonnull item, GZEDiscoverFilterType currentType, NSInteger index) {
            StrongSelfReturnNil(self)
            GZEDiscoverHeaderView *header = (GZEDiscoverHeaderView *)[self.tableView headerViewForSection:3];
            if (currentType == GZEDiscoverFilterType_Language) {
                [header updateLanguageTitle:item.value hightlight:index != 0];
                if (self.mediaType == GZEMediaType_TV) {
                    self.tvsReq.withOriginalLanguage = (index == 0 ? nil : item.key);
                    self.tvLanguageFilterModel.selectIndex = index;
                } else if (self.mediaType == GZEMediaType_Movie) {
                    self.moviesReq.withOriginalLanguage = (index == 0 ? nil : item.key);
                    self.movieLanguageFilterModel.selectIndex = index;
                }
            } else if (currentType == GZEDiscoverFilterType_Genre) {
                [header updateGenreTitle:item.value hightlight:index != 0];
                if (self.mediaType == GZEMediaType_TV) {
                    self.tvsReq.withGenres = (index == 0 ? nil : item.key);
                    self.tvGenreFilterModel.selectIndex = index;
                } else if (self.mediaType == GZEMediaType_Movie) {
                    self.moviesReq.withGenres = (index == 0 ? nil : item.key);
                    self.movieGenreFilterModel.selectIndex = index;
                }
            }
            [self showOrHideFilterView:YES type:currentType];
            [self showOrHideSortView:YES];
            [self loadDataWithMore:NO];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        };
    }
    return _filterView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadDataWithMore:NO];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadDataWithMore:YES];
        }];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate, DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        GZEDiscoverHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([GZEDiscoverHeaderView class])];
        if (!header) {
            header = [[GZEDiscoverHeaderView alloc] initWithReuseIdentifier:NSStringFromClass([GZEDiscoverHeaderView class])];
            WeakSelf(self)
            WeakSelf(header)
            header.didTapMediaButton = ^(GZEMediaType mediaType) {
                StrongSelfReturnNil(self)
                StrongSelfReturnNil(header)
                if (mediaType != self.mediaType) {
                    self.mediaType = mediaType;
                    // 重置一下筛选条件
                    if (self.mediaType == GZEMediaType_TV) {
                        self.tvsReq = [[GZETVDiscoveryReq alloc] init];
                    } else if (self.mediaType == GZEMediaType_Movie) {
                        self.moviesReq = [[GZEMovieDiscoveryReq alloc] init];
                    }
                    [self loadDataWithMore:NO];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                [self showOrHideSortView:YES];
                [self showOrHideFilterView:YES type:self.filterView.viewModel.filterType];
                [header resetFilter];
                self.tvLanguageFilterModel.selectIndex = 0;
                self.movieLanguageFilterModel.selectIndex = 0;
                self.tvGenreFilterModel.selectIndex = 0;
                self.movieGenreFilterModel.selectIndex = 0;
            };
            header.didTapSortButton = ^{
                StrongSelfReturnNil(self)
                [self showOrHideSortView:!self.sortView.isHidden];
                [self showOrHideFilterView:YES type:self.filterView.viewModel.filterType];
            };
            header.didTapLanguageButton = ^{
                StrongSelfReturnNil(self)
                StrongSelfReturnNil(header)
                [self showOrHideSortView:YES];
                if (self.filterView.viewModel.filterType == GZEDiscoverFilterType_Language) {
                    [self showOrHideFilterView:!self.filterView.isHidden type:GZEDiscoverFilterType_Language];
                } else {
                    [header genreArrowIsUp:NO];
                    [self showOrHideFilterView:NO type:GZEDiscoverFilterType_Language];
                }
            };
            header.didTapGenreButton = ^{
                StrongSelfReturnNil(self)
                StrongSelfReturnNil(header)
                [self showOrHideSortView:YES];
                if (self.filterView.viewModel.filterType == GZEDiscoverFilterType_Genre) {
                    [self showOrHideFilterView:!self.filterView.isHidden type:GZEDiscoverFilterType_Genre];
                } else {
                    [header languageArrowIsUp:NO];
                    [self showOrHideFilterView:NO type:GZEDiscoverFilterType_Genre];
                }
            };
            header.didTapFilterButton = ^{
                StrongSelfReturnNil(self)
            };
        }
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return SCREEN_WIDTH * 1.5;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 80;
    }
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return self.discoverArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GZETrendingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GZETrendingCell class])];
        if (!cell) {
            cell = [[GZETrendingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GZETrendingCell class])];
        }
        [cell updateWithModel:self.trendingModel];
        return cell;
    } else if (indexPath.section == 1) {
        GZECompaniesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GZECompaniesCell class])];
        if (!cell) {
            cell = [[GZECompaniesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GZECompaniesCell class])];
        }
        [cell updateWithModel:self.companyArray];
        return cell;
    } else if (indexPath.section == 2) {
        GZEListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GZEListTableViewCell class])];
        if (!cell) {
            cell = [[GZEListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GZEListTableViewCell class])];
        }
        [cell updateWithModel:self.listViewModel];
        return cell;
    } else if (indexPath.section == 3) {
        GZEDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GZEDiscoverCell class])];
        if (!cell) {
            cell = [[GZEDiscoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GZEDiscoverCell class])];
        }
        [cell updateWithModel:self.discoverArray[indexPath.row]];
        return cell;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, progress / (SCREEN_WIDTH / 2.0 * 3));
    if (gradientProgress != self.gradientProgress) {
        if ((gradientProgress >= 0.5 && self.gradientProgress < 0.5) || (self.gradientProgress >= 0.5 && gradientProgress < 0.5)) {
            self.gradientProgress = gradientProgress;
            [self setNeedsStatusBarAppearanceUpdate];
            [self yp_refreshNavigationBarStyle];
        } else {
            self.gradientProgress = gradientProgress;
            [self yp_refreshNavigationBarStyle];
        }
    }
    // 改变UITableView的吸顶位置, 49是header Title占用的高度
    CGFloat navigateBarHeight = self.navigationController.navigationBar.bottom - 49;
    // 设置成(SCREEN_WIDTH / 2.0 * 3)是因为小于这个值时导航栏还有透明度，此时改变tableview的contentInset会有一条黑线，
    // 需要等导航栏完全不透明时再设置
    if (scrollView.contentOffset.y <= (SCREEN_WIDTH / 2.0 * 3) && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= (SCREEN_WIDTH / 2.0 * 3)) {
        scrollView.contentInset = UIEdgeInsetsMake(navigateBarHeight, 0, 0, 0);
    }
    
}

#pragma mark - YPNavigationBarConfigureStyle
- (YPNavigationBarConfigurations)yp_navigtionBarConfiguration {
    YPNavigationBarConfigurations configurations = YPNavigationBarShow;
    if (@available(iOS 13.0, *)) {
        if (self.gradientProgress <= 0) {
            configurations |= YPNavigationBarBackgroundStyleTransparent;
        } else {
            configurations |= YPNavigationBarBackgroundStyleOpaque;
            configurations |= YPNavigationBarBackgroundStyleColor;
        }
    } else {
        if (self.gradientProgress < 0.5) {
            configurations |= YPNavigationBarStyleBlack;
        }
        
        if (self.gradientProgress == 1) {
            configurations |= YPNavigationBarBackgroundStyleOpaque;
        }

        configurations |= YPNavigationBarBackgroundStyleColor;
    }
    return configurations;
}

- (UIColor *)yp_navigationBarTintColor {
    return [UIColor colorWithWhite:1 - self.gradientProgress alpha:1];
}

- (UIColor *)yp_navigationBackgroundColor {
    return [UIColor colorWithWhite:1 alpha:self.gradientProgress];
}

@end
