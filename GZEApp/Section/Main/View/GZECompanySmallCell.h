//
//  GZECompanySmallCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZEBaseCollectionViewCell.h"
@class GZECompanyListItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZECompanySmallCell : GZEBaseCollectionViewCell

- (void)updateWithModel:(GZECompanyListItem *)model;

@end

NS_ASSUME_NONNULL_END
