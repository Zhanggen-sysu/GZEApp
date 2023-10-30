//
//  GZEListCollectionViewCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseCollectionViewCell.h"
@class GZEListCollectionViewModel;
@class GZEListSmallTableViewCellModel;
NS_ASSUME_NONNULL_BEGIN

@protocol GZEListCollectionViewCellDelegate <NSObject>

- (void)listCollectionViewCellDidTapCell:(GZEListSmallTableViewCellModel *)cellModel;

@end

@interface GZEListCollectionViewCell : GZEBaseCollectionViewCell

@property (nonatomic, weak) id<GZEListCollectionViewCellDelegate> delegate;
- (void)updateWithModel:(GZEListCollectionViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
