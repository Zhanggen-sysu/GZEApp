//
//  GZEFilterAdvanceView.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEBaseView.h"
#import "GZEFilterViewModel.h"
@class GZEFilterAdvanceView;

@protocol GZEFilterAdvanceViewDelegate <NSObject>

- (void)filterAdvanceView:(nonnull GZEFilterAdvanceView *)filterView viewModel:(nonnull GZEFilterViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GZEFilterAdvanceView : GZEBaseView

@property (nonatomic, weak) id<GZEFilterAdvanceViewDelegate> delegate;
- (instancetype)initWithFilterType:(GZEFilterType)filterType;

@end

NS_ASSUME_NONNULL_END
