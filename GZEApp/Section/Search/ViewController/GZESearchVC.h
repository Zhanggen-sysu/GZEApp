//
//  GZESearchVC.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import <UIKit/UIKit.h>
@class GZETrendingViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface GZESearchVC : UIViewController

- (instancetype)initWithTrendingViewModel:(GZETrendingViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
