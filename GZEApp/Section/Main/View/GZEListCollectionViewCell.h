//
//  GZEListCollectionViewCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseCollectionViewCell.h"
@class GZEListCollectionViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface GZEListCollectionViewCell : GZEBaseCollectionViewCell

- (void)updateWithModel:(GZEListCollectionViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
