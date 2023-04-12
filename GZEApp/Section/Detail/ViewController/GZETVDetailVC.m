//
//  GZETVDetailVC.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZETVDetailVC.h"
#import "GZEPeopleDetailVC.h"
#import "Macro.h"
#import "GZEDetailManager.h"
#import "GZECommonHelper.h"
#import "GZETVDetailRsp.h"
#import "GZETVDetailViewModel.h"

#import "GZETVDetailSeasonView.h"
#import "GZEKeyWordView.h"
#import "GZEDetailListView.h"
#import "GZEDetailReviewView.h"
#import "GZECopyRightView.h"
#import "GZEDetailNavBarView.h"
#import "GZETVDetailView.h"
#import "GZETVCastView.h"
#import "GZEDetailVIView.h"
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>

@interface GZETVDetailVC () <YPNavigationBarConfigureStyle, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentView;
@property (nonatomic, strong) GZETVDetailView *detailView;
@property (nonatomic, strong) GZEKeyWordView *keywordView;
@property (nonatomic, strong) GZETVCastView *castView;
@property (nonatomic, strong) GZEDetailVIView *viView;
@property (nonatomic, strong) GZETVDetailSeasonView *seasonView;
@property (nonatomic, strong) GZEDetailListView *similarView;
@property (nonatomic, strong) GZEDetailListView *recommendView;
@property (nonatomic, strong) GZEDetailReviewView *reviewView;
@property (nonatomic, strong) GZECopyRightView *cprView;

@property (nonatomic, strong) GZETVDetailViewModel *viewModel;
@property (nonatomic, assign) CGFloat gradientProgress;
@property (nonatomic, strong) GZEDetailManager *manager;
@property (nonatomic, assign) NSInteger tvId;

@property (nonatomic, strong) GZEDetailNavBarView *navBarView;


@end

@implementation GZETVDetailVC

- (instancetype)initWithTVId:(NSInteger)tvId
{
    if (self = [super init]) {
        self.tvId = tvId;
        self.navigationItem.titleView = self.navBarView;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self defineLayout];
    [self loadData];
}

- (void)loadData
{
    [self.manager getTVDetailWithId:self.tvId completion:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
        if (isSuccess) {
            self.viewModel = (GZETVDetailViewModel *)rsp;
            self.contentView.backgroundColor = [GZECommonHelper changeColor:self.viewModel.magicColor deeper:YES degree:20];
            [self.navBarView updateWithTVModel:self.viewModel.detail];
            [self.detailView updateWithModel:self.viewModel.detail magicColor:self.viewModel.magicColor];
            [self.seasonView updateWithModel:self.viewModel.detail.seasons magicColor:self.viewModel.magicColor];
            [self.keywordView updateWithModel:self.viewModel.detail.keywords magicColor:self.viewModel.magicColor];
            [self.castView updateWithModel:self.viewModel.detail.aggregateCredits magicColor:self.viewModel.magicColor];
            [self.viView updateWithImgModel:self.viewModel.detail.images videoModel:self.viewModel.firstVideo magicColor:self.viewModel.magicColor];
            [self.similarView updateWithTVModel:self.viewModel.detail.similar magicColor:self.viewModel.magicColor];
            [self.recommendView updateWithTVModel:self.viewModel.detail.recommendations magicColor:self.viewModel.magicColor];
            [self.reviewView updateWithModel:self.viewModel.detail.reviews magicColor:self.viewModel.magicColor];
            [self.cprView updateWithMagicColor:self.viewModel.magicColor];
        }
    }];
}

- (void)setupSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
}

- (void)defineLayout
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        // 还需要约束下宽度
        make.width.equalTo(self.view);
    }];
    // 处理titleView不居中问题
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300.f);
    }];
}

- (GZEDetailManager *)manager
{
    if (!_manager) {
        _manager = [[GZEDetailManager alloc] init];
    }
    return _manager;
}

- (GZEDetailNavBarView *)navBarView
{
    if (!_navBarView) {
        _navBarView = [[GZEDetailNavBarView alloc] init];
    }
    return _navBarView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        // Tips: 去除scrollView顶部空白区域
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            _scrollView.automaticallyAdjustsScrollIndicatorInsets = NO;
        }
    }
    return _scrollView;
}

- (GZETVDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[GZETVDetailView alloc] init];
    }
    return _detailView;
}

- (GZEKeyWordView *)keywordView
{
    if (!_keywordView) {
        _keywordView = [[GZEKeyWordView alloc] init];
    }
    return _keywordView;
}

- (GZETVDetailSeasonView *)seasonView
{
    if (!_seasonView) {
        _seasonView = [[GZETVDetailSeasonView alloc] init];
    }
    return _seasonView;
}

- (GZETVCastView *)castView
{
    if (!_castView) {
        _castView = [[GZETVCastView alloc] init];
        WeakSelf(self)
        _castView.didTapPeople = ^(NSInteger peopleId) {
            StrongSelfReturnNil(self)
            GZEPeopleDetailVC *vc = [[GZEPeopleDetailVC alloc] initWithPeopleId:peopleId];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _castView;
}

- (GZEDetailVIView *)viView
{
    if (!_viView) {
        _viView = [[GZEDetailVIView alloc] init];
    }
    return _viView;
}

- (GZEDetailListView *)similarView
{
    if (!_similarView) {
        _similarView = [[GZEDetailListView alloc] initWithTitle:@"Recommend For You"];
    }
    return _similarView;
}

// 感觉这个的数据更像similar
- (GZEDetailListView *)recommendView
{
    if (!_recommendView) {
        _recommendView = [[GZEDetailListView alloc] initWithTitle:@"More Like This"];
    }
    return _recommendView;
}

- (GZEDetailReviewView *)reviewView
{
    if (!_reviewView) {
        _reviewView = [[GZEDetailReviewView alloc] init];
    }
    return _reviewView;
}

- (GZECopyRightView *)cprView
{
    if (!_cprView) {
        _cprView = [[GZECopyRightView alloc] init];
    }
    return _cprView;
}

- (UIStackView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIStackView alloc] initWithArrangedSubviews:@[
            self.detailView,
            self.keywordView,
            self.castView,
            self.viView,
            self.seasonView,
            self.recommendView,
            self.similarView,
            self.reviewView,
            self.cprView,
        ]];
        _contentView.axis = UILayoutConstraintAxisVertical;
        _contentView.alignment = UIStackViewAlignmentFill;
        _contentView.distribution = UIStackViewDistributionFill;
        _contentView.spacing = 15.f;
    }
    return _contentView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, progress / (SCREEN_WIDTH / 2 * 3));
    if (gradientProgress != self.gradientProgress) {
        if (gradientProgress >= 1 && self.gradientProgress < 1) {
            [self.navBarView updateView:NO];
        } else if (self.gradientProgress >= 1 && gradientProgress < 1){
            [self.navBarView updateView:YES];
        }
        self.gradientProgress = gradientProgress;
        [self yp_refreshNavigationBarStyle];
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
    return [UIColor whiteColor];
}

- (UIColor *)yp_navigationBackgroundColor {
    UIColor *color = self.viewModel.magicColor ?: [UIColor whiteColor];
    return [color colorWithAlphaComponent:self.gradientProgress];
}

@end
