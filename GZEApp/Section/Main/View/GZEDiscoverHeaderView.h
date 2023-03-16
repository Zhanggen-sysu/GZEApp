//
//  GZEDiscoverHeaderView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GZEDiscoverHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void (^didTapMediaButton)(BOOL isMovie);

@end

NS_ASSUME_NONNULL_END
