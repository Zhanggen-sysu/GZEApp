//
//  GZETrendingReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseReq.h"
#import "GZEEnum.h"

typedef NS_ENUM(NSUInteger, GZETimeWindow) {
    GZETimeWindow_Default,
    GZETimeWindow_Day,
    GZETimeWindow_Week,
};

NS_ASSUME_NONNULL_BEGIN

@interface GZETrendingReq : GZEBaseReq

@property (nonatomic, assign) GZEMediaType mediaType;
@property (nonatomic, assign) GZETimeWindow timeWindow;

@end

NS_ASSUME_NONNULL_END
