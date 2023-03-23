//
//  GZEDiscoverCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/14.
//

#import "GZEBaseTableViewCell.h"
@class GZEDiscoverCellViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface GZEDiscoverCell : GZEBaseTableViewCell

@property (nonatomic, copy) void (^didChangeHeight)(BOOL isWrap);
- (void)updateWithModel:(GZEDiscoverCellViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
