//
//  GZEDiscoverFilterView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/16.
//

#import "GZEBaseView.h"
#import "GZEDiscoverFilterViewModel.h"
@class GZEDiscoverFilterItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZEDiscoverFilterView : GZEBaseView

@property (nonatomic, copy) void (^dismissBlock)(GZEDiscoverFilterType currentType);
@property (nonatomic, copy) void (^selectItemBlock)(GZEDiscoverFilterItem *item, GZEDiscoverFilterType currentType, NSInteger index);
@property (nonatomic, strong, readonly) GZEDiscoverFilterViewModel *viewModel;

- (void)updateWithModel:(GZEDiscoverFilterViewModel *)viewModel;
- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
