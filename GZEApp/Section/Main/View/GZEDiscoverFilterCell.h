//
//  GZEDiscoverFilterCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/17.
//

#import "GZEBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEDiscoverFilterCell : GZEBaseCollectionViewCell

- (void)updateWithString:(NSString *)text;
- (void)updateSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
