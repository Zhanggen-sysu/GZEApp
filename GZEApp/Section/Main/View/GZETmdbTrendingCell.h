//
//  GZETmdbTrendingCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZEBaseTableViewCell.h"
#import "GZEEnum.h"
@class GZETrendingViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface GZETmdbTrendingCell : GZEBaseTableViewCell

@property (nonatomic, copy) void (^didTapItem)(NSInteger Id, GZEMediaType type);

- (void)updateWithModel:(GZETrendingViewModel *)model;

@end

NS_ASSUME_NONNULL_END
