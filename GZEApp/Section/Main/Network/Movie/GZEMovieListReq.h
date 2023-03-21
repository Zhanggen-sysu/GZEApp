//
//  GZEMovieListReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZEBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GZEMovieListType) {
    GZEMovieListType_Default,
    GZEMovieListType_Playing,
    GZEMovieListType_Popular,
    GZEMovieListType_TopRate,
    GZEMovieListType_Upcoming,
};

@interface GZEMovieListReq : GZEBaseReq

@property (nonatomic, copy) NSString *language;
// NSInteger
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, assign) GZEMovieListType type;

@end

NS_ASSUME_NONNULL_END
