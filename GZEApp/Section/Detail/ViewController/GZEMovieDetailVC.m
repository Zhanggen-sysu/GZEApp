//
//  GZEMovieDetailVC.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEMovieDetailVC.h"
#import "GZEMovieDetailView.h"
#import "GZEMovieCastView.h"
#import "GZEMovieVIView.h"
#import "GZEMovieSimilarView.h"
#import "GZEMovieNavBarView.h"
#import "GZEMovieReviewView.h"

#import "GZEDetailManager.h"
#import "GZECommonHelper.h"
#import "GZEMovieDetailViewModel.h"
#import "Macro.h"
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>

@interface GZEMovieDetailVC ()<YPNavigationBarConfigureStyle, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentView;
@property (nonatomic, strong) GZEMovieDetailView *detailView;
@property (nonatomic, strong) GZEMovieCastView *castView;
@property (nonatomic, strong) GZEMovieVIView *viView;
@property (nonatomic, strong) GZEMovieSimilarView *similarView;
@property (nonatomic, strong) GZEMovieSimilarView *recommendView;
@property (nonatomic, strong) GZEMovieReviewView *reviewView;

@property (nonatomic, assign) CGFloat gradientProgress;
@property (nonatomic, strong) GZEDetailManager *manager;
@property (nonatomic, assign) NSInteger movieId;
@property (nonatomic, strong) GZEMovieDetailViewModel *viewModel;

@property (nonatomic, strong) GZEMovieNavBarView *navBarView;

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
    [self loadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Data
- (void)loadData
{
    WeakSelf(self)
    [self.manager getMovieDetailWithId:self.movieId
                            completion:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
        StrongSelfReturnNil(self)
        self.viewModel = (GZEMovieDetailViewModel *)rsp;
        [self updateUI];
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
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
    }];
    [self.castView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
    }];
    [self.viView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
    }];
    [self.similarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
    }];
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
    }];
    [self.reviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
    }];
    // 处理titleView不居中问题
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300.f);
    }];
}

- (void)updateUI
{
    [self.navBarView updateWithModel:self.viewModel.commonInfo];
    self.contentView.backgroundColor = [GZECommonHelper changeColor:self.viewModel.magicColor deeper:YES degree:20];
    [self.detailView updateWithModel:self.viewModel.commonInfo magicColor:self.viewModel.magicColor];
    [self.castView updateWithModel:self.viewModel.crewCast magicColor:self.viewModel.magicColor];
    [self.viView updateWithImgModel:self.viewModel.images videoModel:self.viewModel.firstVideo magicColor:self.viewModel.magicColor];
    [self.similarView updateWithModel:self.viewModel.similar magicColor:self.viewModel.magicColor];
    [self.recommendView updateWithModel:self.viewModel.recommend magicColor:self.viewModel.magicColor];
    [self.reviewView updateWithModel:self.viewModel.reviews magicColor:self.viewModel.magicColor];
}

- (GZEDetailManager *)manager
{
    if (!_manager) {
        _manager = [[GZEDetailManager alloc] init];
    }
    return _manager;
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
            self.castView,
            self.viView,
            self.recommendView,
            self.similarView,
            self.reviewView,
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

- (GZEMovieCastView *)castView
{
    if (!_castView) {
        _castView = [[GZEMovieCastView alloc] init];
    }
    return _castView;
}

- (GZEMovieVIView *)viView
{
    if (!_viView) {
        _viView = [[GZEMovieVIView alloc] init];
    }
    return _viView;
}

- (GZEMovieSimilarView *)similarView
{
    if (!_similarView) {
        _similarView = [[GZEMovieSimilarView alloc] initWithTitle:@"More Like This"];
    }
    return _similarView;
}

- (GZEMovieSimilarView *)recommendView
{
    if (!_recommendView) {
        _recommendView = [[GZEMovieSimilarView alloc] initWithTitle:@"Recommend For You"];
    }
    return _recommendView;
}

- (GZEMovieReviewView *)reviewView
{
    if (!_reviewView) {
        _reviewView = [[GZEMovieReviewView alloc] init];
    }
    return _reviewView;
}

- (GZEMovieNavBarView *)navBarView
{
    if (!_navBarView) {
        _navBarView = [[GZEMovieNavBarView alloc] init];
    }
    return _navBarView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, progress / (SCREEN_WIDTH / 16 * 9));
    if (gradientProgress != self.gradientProgress) {
        if ((gradientProgress >= 0.5 && self.gradientProgress < 0.5) || (self.gradientProgress >= 0.5 && gradientProgress < 0.5)) {
            if (gradientProgress >= 0.5 && self.gradientProgress < 0.5) {
                [self.navBarView updateView:NO];
            } else {
                [self.navBarView updateView:YES];
            }
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
    return [UIColor whiteColor];
}

- (UIColor *)yp_navigationBackgroundColor {
    UIColor *color = self.viewModel.magicColor ?: [UIColor whiteColor];
    return [color colorWithAlphaComponent:self.gradientProgress];
}


@end
