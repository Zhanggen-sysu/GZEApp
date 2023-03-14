//
//  GZETrendingCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZEBaseTableViewCell.h"
@class GZETrendingViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface GZETrendingCell : GZEBaseTableViewCell

- (void)updateWithModel:(GZETrendingViewModel *)model;

@end

NS_ASSUME_NONNULL_END
