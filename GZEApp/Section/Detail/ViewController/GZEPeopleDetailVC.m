//
//  GZEPeopleDetailVC.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEPeopleDetailVC.h"
#import "GZEDetailManager.h"
#import "GZEPeopleDetailRsp.h"
#import "GZEDetailListView.h"
#import "GZEPeopleDetailImageView.h"
#import "Masonry.h"
#import "Macro.h"
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>

#import "GZEPeopleDetailView.h"

@interface GZEPeopleDetailVC () <YPNavigationBarConfigureStyle, UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger peopleId;
@property (nonatomic, strong) GZEDetailManager *manager;
@property (nonatomic, strong) GZEPeopleDetailRsp *viewModel;
@property (nonatomic, assign) CGFloat gradientProgress;

@property (nonatomic, strong) GZEPeopleDetailView *detailView;
@property (nonatomic, strong) GZEDetailListView *castView;
@property (nonatomic, strong) GZEPeopleDetailImageView *imagesView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentView;

@end

@implementation GZEPeopleDetailVC

- (instancetype)initWithPeopleId:(NSInteger)peopleId
{
    if (self = [super init]) {
        self.peopleId = peopleId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self defineLayout];
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

- (void)loadData
{
    WeakSelf(self)
    [self.manager getPeopleDetailWithId:self.peopleId completion:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
        StrongSelfReturnNil(self)
        if (isSuccess) {
            self.viewModel = (GZEPeopleDetailRsp *)rsp;
            [self.detailView updateWithModel:self.viewModel];
            [self.castView updateWithCombinedCreditModel:self.viewModel.combinedCredits];
            [self.imagesView updateWithImages:self.viewModel.images taggedImages:self.viewModel.taggedImages];
        }
    }];
}

- (void)setupSubviews
{
    self.view.backgroundColor = RGBColor(245, 245, 245);
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

- (GZEDetailListView *)castView
{
    if (!_castView) {
        _castView = [[GZEDetailListView alloc] initWithTitle:@"Know For"];
    }
    return _castView;
}

- (GZEPeopleDetailImageView *)imagesView
{
    if (!_imagesView) {
        _imagesView = [[GZEPeopleDetailImageView alloc] init];
    }
    return _imagesView;
}

- (GZEPeopleDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[GZEPeopleDetailView alloc] init];
    }
    return _detailView;
}

- (UIStackView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIStackView alloc] initWithArrangedSubviews:@[
            self.detailView,
            self.castView,
            self.imagesView,
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
//        if (gradientProgress >= 1 && self.gradientProgress < 1) {
//            [self.navBarView updateView:NO];
//        } else if (self.gradientProgress >= 1 && gradientProgress < 1){
//            [self.navBarView updateView:YES];
//        }
        self.gradientProgress = gradientProgress;
        [self yp_refreshNavigationBarStyle];
        [self setNeedsStatusBarAppearanceUpdate];
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
