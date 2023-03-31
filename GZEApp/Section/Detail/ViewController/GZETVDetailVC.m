//
//  GZETVDetailVC.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZETVDetailVC.h"
#import "Macro.h"
#import "GZEDetailManager.h"
#import "GZETVDetailViewModel.h"
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>

@interface GZETVDetailVC () <YPNavigationBarConfigureStyle, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentView;

@property (nonatomic, strong) GZETVDetailViewModel *viewModel;
@property (nonatomic, assign) CGFloat gradientProgress;
@property (nonatomic, strong) GZEDetailManager *manager;
@property (nonatomic, assign) NSInteger tvId;


@end

@implementation GZETVDetailVC

- (instancetype)initWithTVId:(NSInteger)tvId
{
    if (self = [super init]) {
        self.tvId = tvId;
//        self.navigationItem.titleView = self.navBarView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        if ((gradientProgress >= 0.5 && self.gradientProgress < 0.5) || (self.gradientProgress >= 0.5 && gradientProgress < 0.5)) {
//            if (gradientProgress >= 0.5 && self.gradientProgress < 0.5) {
//                [self.navBarView updateView:NO];
//            } else {
//                [self.navBarView updateView:YES];
//            }
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
