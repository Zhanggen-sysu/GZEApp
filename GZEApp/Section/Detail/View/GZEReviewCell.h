//
//  GZEReviewCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/30.
//

#import "GZEBaseTableViewCell.h"
@class GZEReviewItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZEReviewCell : GZEBaseTableViewCell

@property (nonatomic, copy) void (^didChangeHeight)(BOOL isExpand);

- (void)updateWithModel:(GZEReviewItem *)review magicColor:(UIColor *)magicColor;

@end

NS_ASSUME_NONNULL_END
