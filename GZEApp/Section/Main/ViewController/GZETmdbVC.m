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
#import "GZEMovieListRsp.h"
#import "GZECompanyListRsp.h"
#import "GZECommonHelper.h"
#import "GZETrendingViewModel.h"
#import "GZEListCollectionViewModel.h"
#import "GZETrendingRsp.h"
#import "GZETVListRsp.h"

#import "UIView+GZEExtension.h"
#import "GZETrendingCell.h"
#import "GZECompaniesCell.h"
#import "GZEListTableViewCell.h"
#import "CYLTabBarController.h"
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>

@interface GZETmdbVC () <YPNavigationBarConfigureStyle, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GZETmdbListManager *manager;

@property (nonatomic, strong) GZETrendingViewModel *trendingModel;
@property (nonatomic, strong) NSMutableArray<GZEListCollectionViewModel *> *listViewModel;
@property (nonatomic, copy) NSArray *companyArray;
@property (nonatomic, assign) CGFloat gradientProgress;

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
    
    
}

- (void)loadDataWithMore:(BOOL)loadMore
{
//    self.manager
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

- (UIButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 40)];
        [_searchBtn setImage:kGetImage(@"search-white") forState:UIControlStateNormal];
        [_searchBtn setTitle:@"Search Movie, TV, Person..." forState:UIControlStateNormal];
        _searchBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _searchBtn.titleLabel.font = kFont(14.f);
        _searchBtn.titleLabel.textColor = [UIColor whiteColor];
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.layer.cornerRadius = 20;
        _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
        _searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
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
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
