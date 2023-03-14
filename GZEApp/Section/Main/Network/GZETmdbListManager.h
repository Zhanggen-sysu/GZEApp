//
//  GZETmdbListManager.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import <Foundation/Foundation.h>
#import "GZEMovieListReq.h"
#import "GZECompanyListReq.h"
#import "GZETrendingReq.h"
#import "GZETVListReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZETmdbListManager : NSObject

- (void)getMovieListType:(GZEMovieListType)type loadMore:(BOOL)loadMore block:(GZECommonRspBlock)block;

- (void)getCompanyListType:(GZECompanyListType)type block:(GZECommonRspBlock)block;

- (void)getTrendingList:(GZEMediaType)type timeWindow:(GZETimeWindow)timeWindow block:(GZECommonRspBlock)block;

- (void)getTVListType:(GZETVListType)type loadMore:(BOOL)loadMore block:(GZECommonRspBlock)block;

@end

NS_ASSUME_NONNULL_END