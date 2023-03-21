//
//  GZEListSmallTableViewCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseTableViewCell.h"
@class GZEListSmallTableViewCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface GZEListSmallTableViewCell : GZEBaseTableViewCell

- (void)updateWithIndex:(NSInteger)index model:(GZEListSmallTableViewCellModel *)model;

@end

NS_ASSUME_NONNULL_END
