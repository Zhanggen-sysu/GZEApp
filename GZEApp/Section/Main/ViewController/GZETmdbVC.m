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
#import "GZEDiscoverCellViewModel.h"

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

@end

@implementation GZETmdbVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self defineLayout];
    self.trendingModel = [[GZETrendingViewModel alloc] init];
    self.listViewModel = [NSMutableArray arrayWithObjects:
                          [GZEListCollectionViewModel new],
                          [GZEListCollectionViewModel new],
                          [GZEListCollectionViewModel new],
                          [GZEListCollectionViewModel new], nil];
    self.moviesReq = [[GZEMovieDiscoveryReq alloc] init];
    self.mediaType = GZEMediaType_Movie;
    [self loadData];
    self.navigationItem.titleView = self.searchBtn;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.gradientProgress < 0.5 ? UIStatusBarStyleLightContent : UIStatusBarStyleDarkContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

#pragma mark - Data
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
        [[GZEGlobalConfig shareConfig] getGenresWithType:GZEMediaType_Movie completion:^(NSDictionary<NSNumber *,NSString *> * _Nonnull genres) {
            dispatch_group_leave(newGroup);
        }];
        [[GZEGlobalConfig shareConfig] getGenresWithType:GZEMediaType_TV completion:nil];
    });
    dispatch_group_enter(newGroup);
    dispatch_async(queue, ^{
        [self.manager getMovieDiscoverWithReq:self.moviesReq loadMore:NO block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
            GZEMovieListRsp *response = (GZEMovieListRsp *)rsp;
            self.moviesRsp = response;
            dispatch_group_leave(newGroup);
        }];
    });
    
    dispatch_group_notify(newGroup, dispatch_get_main_queue(), ^{
        [self updateTableView:NO];
    });
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
        }
        [self.tableView reloadData];
    }
}

- (void)loadDataWithMore:(BOOL)loadMore
{
    
//    WeakSelf(self)
//    [self.manager getMovieDiscoverloadMore:loadMore block:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
//        StrongSelfReturnNil(self)
//        if (isSuccess) {
//            GZEMovieListRsp *response = (GZEMovieListRsp *)rsp;
//            if (loadMore) {
//                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//                NSInteger cnt = self.discoverArray.count;
//                [response.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [indexPaths addObject:[NSIndexPath indexPathForRow:cnt+idx inSection:3]];
//                    [self.discoverArray addObject:[GZEDiscoverCellViewModel viewModelWithMovieItem:obj]];
//                }];
//                // 局部刷新
//                [self.tableView beginUpdates];
//                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//                [self.tableView endUpdates];
//            } else {
//                // 全局刷新
//                self.discoverArray = [[NSMutableArray alloc] init];
//                [response.results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [self.discoverArray addObject:[GZEDiscoverCellViewModel viewModelWithMovieItem:obj]];
//                }];
//                [self.tableView reloadData];
//            }
//        } else {
//            [GZECommonHelper showMessage:errorMessage inView:self.view duration:1.5];
//        }
//    }];
}

- (GZETmdbListManager *)manager
{
    if (!_manager) {
        _manager = [[GZETmdbListManager alloc] init];
    }
    return _manager;
}

#pragma mark - UI
- (void)setupSubviews
{
    [self.view addSubview:self.tableView];
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
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [self loadDataWithMore:YES];
//        }];
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
        }
        return header;
    }
    return nil;
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
    CGFloat gradientProgress = scrollView.contentOffset.y / (SCREEN_WIDTH / 2.0 * 3);
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
