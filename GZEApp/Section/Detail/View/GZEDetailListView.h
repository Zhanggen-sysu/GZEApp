//
//  GZEDetailListView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEBaseView.h"
@class GZEMovieListRsp;
@class GZETVListRsp;
@class GZECombinedCreditsRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEDetailListView : GZEBaseView

@property (nonatomic, copy) void (^didTapMovie)(NSInteger movieId);
@property (nonatomic, copy) void (^didTapTv)(NSInteger tvId);


@end

NS_ASSUME_NONNULL_END
