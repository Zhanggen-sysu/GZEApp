//
//  SceneDelegate+CYLTabBar.m
//  GZEApp
//
//  Created by GenZhang on 2023/2/28.
//

#import "SceneDelegate+CYLTabBar.h"
#import "CYLTabBarController.h"
#import "GZETmdbVC.h"
#import "GZEBookMainVC.h"
#import "Macro.h"
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>

@implementation SceneDelegate (CYLTabBar)

- (void)configureForTabBarViewController {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    UITabBar *tabAppearance = [UITabBar appearance];
    tabAppearance.backgroundColor = RGBColor(245, 245, 245);
    CYLTabBarController *vc = [CYLTabBarController tabBarControllerWithViewControllers:[self viewControllers]
                                                                 tabBarItemsAttributes:[self tabBarItemsAttributes]];
    YPNavigationController *nav = [[YPNavigationController alloc] initWithRootViewController:vc];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
}

- (NSArray *)viewControllers {
    // 影视VC
    GZETmdbVC *tmdbVC = [[GZETmdbVC alloc] init];
    YPNavigationController *tmdbNC = [[YPNavigationController alloc] initWithRootViewController:tmdbVC];
    [tmdbNC cyl_setHideNavigationBarSeparator:YES];
    
    GZEBookMainVC *bookVC = [[GZEBookMainVC alloc] init];
    YPNavigationController *bookNC = [[YPNavigationController alloc] initWithRootViewController:bookVC];
    [bookNC cyl_setHideNavigationBarSeparator:YES];
    
    NSArray *viewControllersArray = @[tmdbNC, bookNC];
    return viewControllersArray;
}

- (NSArray *)tabBarItemsAttributes {
    NSDictionary *imdbTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"Video",
        CYLTabBarItemImage: @"film-line",
        CYLTabBarItemSelectedImage: @"film-fill",
    };
    NSDictionary *bookTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"Book",
        CYLTabBarItemImage: @"book-line",
        CYLTabBarItemSelectedImage: @"book-fill",
    };
    
    NSArray *tabBarItemsAttributes = @[
        imdbTabBarItemsAttributes,
        bookTabBarItemsAttributes,
    ];
    return tabBarItemsAttributes;
}

@end
