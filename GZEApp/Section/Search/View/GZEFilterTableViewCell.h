//
//  GZEFilterTableViewCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/5/30.
//

#import "GZEBaseTableViewCell.h"
@class GZEFilterModel;
@class GZEFilterTableViewCell;

@protocol GZEFilterTableViewCellDelegate <NSObject>

- (void)filterCell:(nonnull GZEFilterTableViewCell *)cell selectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GZEFilterTableViewCell : GZEBaseTableViewCell

@property (nonatomic, weak) id<GZEFilterTableViewCellDelegate> delegate;
@property (nonatomic, strong, readonly) GZEFilterModel *model;
- (void)updateWithModel:(GZEFilterModel *)model;

@end

NS_ASSUME_NONNULL_END
