//
//  GZESearchResultCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/12.
//

#import "GZEBaseTableViewCell.h"
@class GZEMovieListItem;
@class GZETVListItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZESearchResultCell : GZEBaseTableViewCell

- (void)updateWithModel:(GZEMovieListItem *)result;
- (void)updateWithTVModel:(GZETVListItem *)result;

@end

NS_ASSUME_NONNULL_END
