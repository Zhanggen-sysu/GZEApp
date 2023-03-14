//
//  GZECompaniesCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZEBaseTableViewCell.h"
@class GZECompanyListItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZECompaniesCell : GZEBaseTableViewCell

- (void)updateWithModel:(NSArray<GZECompanyListItem *> *)model;

@end

NS_ASSUME_NONNULL_END
