//
//  GZEMovieDetailVC.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEMovieDetailVC.h"
#import "GZEPeopleDetailVC.h"
#import "GZEMovieDetailView.h"
#import "GZEMovieCastView.h"
#import "GZEDetailVIView.h"
#import "GZEDetailListView.h"
#import "GZEDetailNavBarView.h"
#import "GZEDetailReviewView.h"
#import "GZECopyRightView.h"
#import "GZEKeyWordView.h"
#import "GZESearchResultVC.h"
#import "GZEFilterViewModel.h"
#import "GZECommonHelper.h"
#import "GZEMovieDetailViewModel.h"
#import "Macro.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>
#import <GKPhotoBrowser/GKPhotoBrowser.h>

@interface GZEMovieDetailVC ()<YPNavigationBarConfigureStyle, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentView;
@property (nonatomic, strong) GZEMovieDetailView *detailView;
@property (nonatomic, strong) GZEKeyWordView *keywordView;
@property (nonatomic, strong) GZEMovieCastView *castView;
@property (nonatomic, strong) GZEDetailVIView *viView;
@property (nonatomic, strong) GZEDetailListView *similarView;
@property (nonatomic, strong) GZEDetailListView *recommendView;
@property (nonatomic, strong) GZEDetailReviewView *reviewView;
@property (nonatomic, strong) GZECopyRightView *cprView;

@property (nonatomic, assign) CGFloat gradientProgress;
@property (nonatomic, assign) NSInteger movieId;
@property (nonatomic, strong) GZEMovieDetailViewModel *viewModel;

@property (nonatomic, strong) GZEDetailNavBarView *navBarView;

@end

@implementation GZEMovieDetailVC

- (instancetype)initWithMovieId:(NSInteger)movieId
{
    if (self = [super init]) {
        self.movieId = movieId;
        self.navigationItem.titleView = self.navBarView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self defineLayout];
    [self bindViewModel];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Data
- (void)bindViewModel
{
    self.viewModel = [[GZEMovieDetailViewModel alloc] initWithMovieId:self.movieId];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[self.viewModel.reqCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } error:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSString *errorMessage = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
        [GZECommonHelper showMessage:errorMessage inView:self.view duration:1];
    }];
    RAC(self.cprView, backgroundColor) = RACObserve(self.viewModel, magicColor);
    RAC(self.contentView, backgroundColor) = [RACObserve(self.viewModel, magicColor) map:^id _Nullable(id  _Nullable value) {
        return [GZECommonHelper changeColor:(UIColor *)value deeper:YES degree:20];
    }];
    WeakSelf(self)
    // 这个会触发3次，第3次两个属性才都有值，写到外面是保证各模块分开刷
    [[[RACSignal combineLatest:@[RACObserve(self.viewModel, commonInfo), RACObserve(self.viewModel, magicColor)]] skip:2] subscribeNext:^(RACTuple * _Nullable x) {
        StrongSelfReturnNil(self)
        [self.detailView updateWithModel:self.viewModel.commonInfo magicColor:self.viewModel.magicColor];
    }];
    
    [[[RACSignal combineLatest:@[RACObserve(self.viewModel, keyword), RACObserve(self.viewModel, magicColor)]] skip:2] subscribeNext:^(RACTuple * _Nullable x) {
        StrongSelfReturnNil(self)
        [self.keywordView updateWithModel:self.viewModel.keyword magicColor:self.viewModel.magicColor];
    }];
    
    [[[RACSignal combineLatest:@[RACObserve(self.viewModel, crewCast), RACObserve(self.viewModel, magicColor)]] skip:2] subscribeNext:^(RACTuple * _Nullable x) {
        StrongSelfReturnNil(self)
        [self.castView updateWithModel:self.viewModel.crewCast magicColor:self.viewModel.magicColor];
    }];
    
    [[[RACSignal combineLatest:@[RACObserve(self.viewModel, images), RACObserve(self.viewModel, magicColor), RACObserve(self.viewModel, firstVideo)]] skip:3] subscribeNext:^(RACTuple * _Nullable x) {
        StrongSelfReturnNil(self)
        [self.viView updateWithImgModel:self.viewModel.images videoModel:self.viewModel.firstVideo magicColor:self.viewModel.magicColor];
    }];
    
    [[[RACSignal combineLatest:@[RACObserve(self.viewModel, reviews), RACObserve(self.viewModel, magicColor)]] skip:2] subscribeNext:^(RACTuple * _Nullable x) {
        StrongSelfReturnNil(self)
        [self.reviewView updateWithModel:self.viewModel.reviews magicColor:self.viewModel.magicColor];
    }];
    
    [[[RACSignal combineLatest:@[RACObserve(self.viewModel, similarVM), RACObserve(self.viewModel, magicColor)]] skip:2] subscribeNext:^(RACTuple * _Nullable x) {
        StrongSelfReturnNil(self)
        [self.similarView bindViewModel:self.viewModel.similarVM];
    }];
    
    [[[RACSignal combineLatest:@[RACObserve(self.viewModel, recommendVM), RACObserve(self.viewModel, magicColor)]] skip:2] subscribeNext:^(RACTuple * _Nullable x) {
        StrongSelfReturnNil(self)
        [self.recommendView bindViewModel:self.viewModel.recommendVM];
    }];
}

#pragma mark - UI
- (void)setupSubviews
{
    // 不加背景颜色看起来会有卡顿
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

- (UIStackView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIStackView alloc] initWithArrangedSubviews:@[
            self.detailView,
            self.keywordView,
            self.castView,
            self.viView,
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

- (GZEMovieDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[GZEMovieDetailView alloc] init];
    }
    return _detailView;
}

- (GZEKeyWordView *)keywordView
{
    if (!_keywordView) {
        _keywordView = [[GZEKeyWordView alloc] init];
        WeakSelf(self)
        _keywordView.didTapKeyword = ^(GZEGenreItem * _Nonnull keyword) {
            StrongSelfReturnNil(self)
            GZEFilterViewModel *viewModel = [GZEFilterViewModel createFilterModelWithKeywords:@[keyword] mediaType:GZEMediaType_Movie];
            GZESearchResultVC *vc = [[GZESearchResultVC alloc] initWithViewModel:viewModel];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _keywordView;
}

- (GZEMovieCastView *)castView
{
    if (!_castView) {
        _castView = [[GZEMovieCastView alloc] init];
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
        WeakSelf(self)
        _viView.didTapImage = ^(NSArray * _Nonnull photos, NSInteger idx) {
            StrongSelfReturnNil(self)
            GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:idx];
            browser.showStyle = GKPhotoBrowserShowStyleZoom;
            browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
            browser.loadStyle = GKPhotoBrowserLoadStyleCustom;
            browser.originLoadStyle = GKPhotoBrowserLoadStyleCustom;
//            browser.delegate = self;
            [browser showFromVC:self];
        };
    }
    return _viView;
}

- (GZEDetailListView *)similarView
{
    if (!_similarView) {
        _similarView = [[GZEDetailListView alloc] init];
        WeakSelf(self)
        _similarView.didTapMovie = ^(NSInteger movieId) {
            StrongSelfReturnNil(self)
            GZEMovieDetailVC *vc = [[GZEMovieDetailVC alloc] initWithMovieId:movieId];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _similarView;
}

// 感觉这个的数据更像similar
- (GZEDetailListView *)recommendView
{
    if (!_recommendView) {
        _recommendView = [[GZEDetailListView alloc] init];
        WeakSelf(self)
        _recommendView.didTapMovie = ^(NSInteger movieId) {
            StrongSelfReturnNil(self)
            GZEMovieDetailVC *vc = [[GZEMovieDetailVC alloc] initWithMovieId:movieId];
            [self.navigationController pushViewController:vc animated:YES];
        };
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

- (GZEDetailNavBarView *)navBarView
{
    if (!_navBarView) {
        _navBarView = [[GZEDetailNavBarView alloc] init];
    }
    return _navBarView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, progress / (SCREEN_WIDTH / 16 * 9));
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
