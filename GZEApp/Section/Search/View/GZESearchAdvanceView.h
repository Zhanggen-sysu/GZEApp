//
//  GZESearchAdvanceView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseView.h"
#import <JXCategoryListContainerView.h>
@class GZEFilterViewModel;

@protocol GZESearchAdvanceViewDelegate <NSObject>

- (void)searchAdvanceViewConfirm:(nonnull GZEFilterViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GZESearchAdvanceView : GZEBaseView <JXCategoryListContentViewDelegate>

@property (nonatomic, weak) id<GZESearchAdvanceViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
