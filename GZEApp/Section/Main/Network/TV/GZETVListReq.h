//
//  GZETVListReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseReq.h"

typedef NS_ENUM(NSUInteger, GZETVListType) {
    GZETVListType_Default,
    GZETVListType_AiringToday,
    GZETVListType_OnTheAir,
    GZETVListType_Popular,
    GZETVListType_TopRated,
};

NS_ASSUME_NONNULL_BEGIN

@interface GZETVListReq : GZEBaseReq

@property (nonatomic, copy) NSString *language;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) GZETVListType type;

@end

NS_ASSUME_NONNULL_END
