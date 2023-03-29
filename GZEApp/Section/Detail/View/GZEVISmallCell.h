//
//  GZEVISmallCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEBaseCollectionViewCell.h"
@class GZEYTVideoRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEVISmallCell : GZEBaseCollectionViewCell

- (void)updateWithUrl:(NSURL *)url;
// Youtube Key
- (void)updateWithVideo:(GZEYTVideoRsp *)model;

@end

NS_ASSUME_NONNULL_END
