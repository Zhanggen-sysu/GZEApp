//
//  GZEPeopleCreditCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/7.
//

#import "GZEBaseCollectionViewCell.h"
@class GZEMediaCast;
@class GZEMediaCrew;

NS_ASSUME_NONNULL_BEGIN

@interface GZEPeopleCreditCell : GZEBaseCollectionViewCell

- (void)updateWithCastModel:(GZEMediaCast *)cast;
- (void)updateWithCrewModel:(GZEMediaCrew *)crew;

@end

NS_ASSUME_NONNULL_END
