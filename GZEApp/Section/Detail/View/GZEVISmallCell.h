//
//  GZEVISmallCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEVISmallCell : GZEBaseCollectionViewCell

- (void)updateWithUrl:(NSURL *)url;
// Youtube Key
- (void)updateWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
