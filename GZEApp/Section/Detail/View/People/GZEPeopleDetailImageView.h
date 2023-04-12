//
//  GZEPeopleDetailImageView.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/12.
//

#import "GZEBaseView.h"
@class GZETmdbImageRsp;
@class GZETagImageRsp;
NS_ASSUME_NONNULL_BEGIN

@interface GZEPeopleDetailImageView : GZEBaseView

- (void)updateWithImages:(GZETmdbImageRsp *)images taggedImages:(GZETagImageRsp *)taggedImages;

@end

NS_ASSUME_NONNULL_END
