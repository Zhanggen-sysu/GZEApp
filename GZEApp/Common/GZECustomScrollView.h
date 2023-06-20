//
//  GZECustomScrollView.h
//  GZEApp
//
//  Created by GenZhang on 2023/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 处理scrollView嵌套的情况，允许多个手势同时响应，具体的临界点通过scrollViewDidScroll处理
@interface GZECustomScrollView : UIScrollView <UIGestureRecognizerDelegate>

@end

NS_ASSUME_NONNULL_END
