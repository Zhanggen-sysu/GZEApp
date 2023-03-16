//
//  GZETmdbListManager.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZETmdbListManager.h"
#import "GZEMovieListRsp.h"
#import "GZECompanyListRsp.h"
#import "GZETrendingRsp.h"
#import "GZETVListRsp.h"

@interface GZETmdbListManager ()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger tvPage;

@property (nonatomic, assign) NSInteger discoverPage;

@end

@implementation GZETmdbListManager

- (void)getMovieListType:(GZEMovieListType)type loadMore:(BOOL)loadMore block:(GZECommonRspBlock)block
{
    self.page = loadMore ? ++self.page : 1;
    GZEMovieListReq *req = [[GZEMovieListReq alloc] init];
    req.type = type;
    req.page = self.page;
    [req startRequestWithRspClass:[GZEMovieListRsp class] completeBlock:block];
}

- (void)getTVListType:(GZETVListType)type loadMore:(BOOL)loadMore block:(GZECommonRspBlock)block
{
    self.tvPage = loadMore ? ++self.tvPage : 1;
    GZETVListReq *req = [[GZETVListReq alloc] init];
    req.type = type;
    req.page = self.tvPage;
    [req startRequestWithRspClass:[GZETVListRsp class] completeBlock:block];
}

- (void)getCompanyListType:(GZECompanyListType)type block:(GZECommonRspBlock)block
{
    GZECompanyListReq *req = [[GZECompanyListReq alloc] init];
    req.type = type;
    [req startRequestWithRspClass:[GZECompanyListRsp class] completeBlock:block];
}

- (void)getTrendingList:(GZEMediaType)type timeWindow:(GZETimeWindow)timeWindow block:(GZECommonRspBlock)block
{
    GZETrendingReq *req = [[GZETrendingReq alloc] init];
    req.mediaType = type;
    req.timeWindow = timeWindow;
    [req startRequestWithRspClass:[GZETrendingRsp class] completeBlock:block];
}

- (void)getMovieDiscoverWithReq:(GZEMovieDiscoveryReq *)req loadMore:(BOOL)loadMore block:(GZECommonRspBlock)block;
{
    self.discoverPage = loadMore ? ++self.discoverPage : 1;
    req.page = self.discoverPage;
    [req startRequestWithRspClass:[GZEMovieListRsp class] completeBlock:block];
}

@end
