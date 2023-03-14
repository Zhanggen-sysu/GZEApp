//
//  GZEListTableViewCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseTableViewCell.h"
@class GZEListCollectionViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface GZEListTableViewCell : GZEBaseTableViewCell

- (void)updateWithModel:(NSArray<GZEListCollectionViewModel *> *)viewModel;

@end

NS_ASSUME_NONNULL_END
