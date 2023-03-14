//
//  SceneDelegate+CYLTabBar.m
//  GZEApp
//
//  Created by GenZhang on 2023/2/28.
//

#import "SceneDelegate+CYLTabBar.h"
#import "CYLTabBarController.h"
#import "GZETmdbVC.h"
#import <YPNavigationBarTransition/YPNavigationBarTransition.h>

@implementation SceneDelegate (CYLTabBar)

- (void)configureForTabBarViewController {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
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
    NSArray *viewControllersArray = @[tmdbNC];
    return viewControllersArray;
}

- (NSArray *)tabBarItemsAttributes {
    NSDictionary *imdbTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"Video",
        CYLTabBarItemImage: @"film-line",
        CYLTabBarItemSelectedImage: @"film-fill",
    };
    
    NSArray *tabBarItemsAttributes = @[
        imdbTabBarItemsAttributes,
    ];
    return tabBarItemsAttributes;
}

@end
