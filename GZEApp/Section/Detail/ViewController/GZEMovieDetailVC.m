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
#import "GZETmdbImageItem.h"
#import "GZETmdbImageRsp.h"
#import "GZEDetailManager.h"
#import "GZECommonHelper.h"
#import "GZEMovieDetailViewModel.h"
#import "Macro.h"
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
@property (nonatomic, strong) GZEDetailManager *manager;
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
        [self.navBarView updateWithModel:self.viewModel.commonInfo];
        self.contentView.backgroundColor = [GZECommonHelper changeColor:self.viewModel.magicColor deeper:YES degree:20];
        [self.detailView updateWithModel:self.viewModel.commonInfo magicColor:self.viewModel.magicColor];
        [self.keywordView updateWithModel:self.viewModel.keyword magicColor:self.viewModel.magicColor];
        [self.castView updateWithModel:self.viewModel.crewCast magicColor:self.viewModel.magicColor];
        [self.viView updateWithImgModel:self.viewModel.images videoModel:self.viewModel.firstVideo magicColor:self.viewModel.magicColor];
        [self.similarView updateWithModel:self.viewModel.similar magicColor:self.viewModel.magicColor];
        [self.recommendView updateWithModel:self.viewModel.recommend magicColor:self.viewModel.magicColor];
        [self.reviewView updateWithModel:self.viewModel.reviews magicColor:self.viewModel.magicColor];
        [self.cprView updateWithMagicColor:self.viewModel.magicColor];
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
        _similarView = [[GZEDetailListView alloc] initWithTitle:@"Recommend For You"];
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
        _recommendView = [[GZEDetailListView alloc] initWithTitle:@"More Like This"];
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

//#pragma mark - GZEImageBrowserDelegate
//- (NSInteger)getImageBrowserCount:(GZEImageBrowser *)browser
//{
//    return self.viewModel.firstVideo ? 9 : 10;
//}
//
//- (NSString *)imageBrowser:(GZEImageBrowser *)browser imageUrlAtIndex:(NSInteger)idx
//{
//    GZETmdbImageItem *imageItem = self.viewModel.images.backdrops[idx];
//    NSString *backdropPath = [NSString stringWithFormat:@"%@w780%@", API_IMG_BASEURL, imageItem.filePath];
//    return backdropPath;
//}
//
//- (UIImage *)imageBrowser:(GZEImageBrowser *)browser defaultImageAtIndex:(NSInteger)idx
//{
//    GZETmdbImageItem *imageItem = self.viewModel.images.backdrops[idx];
//    return imageItem.aspectRatio > 1 ? kGetImage(@"default-backdrop") : kGetImage(@"default-poster");
//}

@end
