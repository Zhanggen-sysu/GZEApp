//
//  GZESearchResultVC.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/12.
//

#import <UIKit/UIKit.h>
@class GZEFilterViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface GZESearchResultVC : UIViewController

- (instancetype)initWithViewModel:(GZEFilterViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
