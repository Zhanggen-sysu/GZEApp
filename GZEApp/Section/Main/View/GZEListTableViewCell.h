//
//  GZEListTableViewCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@class GZEListSmallTableViewCellModel;
@class GZEListCollectionViewModel;

@protocol GZEListTableViewCellDelegate <NSObject>

- (void)listTableViewCellDidTapList:(NSString *)listName;
- (void)listTableViewCellDidTapCell:(GZEListSmallTableViewCellModel *)cellModel;

@end

@interface GZEListTableViewCell : GZEBaseTableViewCell

@property (nonatomic, weak) id<GZEListTableViewCellDelegate> delegate;
- (void)updateWithModel:(NSArray<GZEListCollectionViewModel *> *)viewModel;

@end

NS_ASSUME_NONNULL_END
