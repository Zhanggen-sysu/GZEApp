//
//  GZEDetailListCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEBaseCollectionViewCell.h"
@class GZEMovieListItem;
@class GZETVListItem;

NS_ASSUME_NONNULL_BEGIN

// MARK: cell会复用，但由于不能重复绑定同一个keypath，所以cell内部要直接赋值而不是用绑定
@interface GZEDetailListCell : GZEBaseCollectionViewCell

@end

NS_ASSUME_NONNULL_END
