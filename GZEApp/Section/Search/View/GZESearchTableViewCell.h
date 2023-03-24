//
//  GZESearchTableViewCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import "GZEBaseTableViewCell.h"
@class GZESearchCellViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface GZESearchTableViewCell : GZEBaseTableViewCell

- (void)updateWithModel:(GZESearchCellViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
