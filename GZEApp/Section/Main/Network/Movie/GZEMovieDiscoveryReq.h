//
//  GZEMovieDiscoveryReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZEBaseReq.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, GZEMovieDiscoverySortType) {
    GZEMovieDiscoverySortType_Default,
    GZEMovieDiscoverySortType_PopularityDesc,
    GZEMovieDiscoverySortType_PopularityAsc,
    GZEMovieDiscoverySortType_ReleaseDateDesc,
    GZEMovieDiscoverySortType_ReleaseDateAsc,
    GZEMovieDiscoverySortType_RevenueDesc,
    GZEMovieDiscoverySortType_RevenueAsc,
    GZEMovieDiscoverySortType_PrimaryReleaseDateDesc,
    GZEMovieDiscoverySortType_PrimaryReleaseDateAsc,
    GZEMovieDiscoverySortType_OriginalTitleDesc,
    GZEMovieDiscoverySortType_OriginalTitleAsc,
    GZEMovieDiscoverySortType_VoteAverageDesc,
    GZEMovieDiscoverySortType_VoteAverageAsc,
    GZEMovieDiscoverySortType_VoteCountDesc,
    GZEMovieDiscoverySortType_VoteCountAsc,
};

typedef NS_ENUM(NSUInteger, GZEMovieDiscoveryWatchMonetizationType) {
    GZEMovieDiscoveryWatchMonetizationType_Default,
    GZEMovieDiscoveryWatchMonetizationType_Flatrate,
    GZEMovieDiscoveryWatchMonetizationType_Free,
    GZEMovieDiscoveryWatchMonetizationType_Ads,
    GZEMovieDiscoveryWatchMonetizationType_Rent,
    GZEMovieDiscoveryWatchMonetizationType_Buy,
};
// 回包和MovieListRsp一样
@interface GZEMovieDiscoveryReq : GZEBaseReq
// en-US
@property (nonatomic, copy) NSString *language;
// ISO 3166-1 例如 CN
@property (nonatomic, copy) NSString *region;

@property (nonatomic, copy) NSString *sortBy;

// 分级信息，各国不一样，需要请求/certification/movie/list
@property (nonatomic, copy) NSString *certificationCountry;
// 下面三个字段需要指定certificationCountry
@property (nonatomic, copy) NSString *certification;
@property (nonatomic, copy) NSString *certificationLTE;
@property (nonatomic, copy) NSString *certificationGte;

@property (nonatomic, assign) BOOL includeAdult;
@property (nonatomic, assign) BOOL includeVideo;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger primaryReleaseYear;
// 示例：2011-01-01
@property (nonatomic, copy) NSString *primaryReleaseDateGte;
@property (nonatomic, copy) NSString *primaryReleaseDateLTE;
@property (nonatomic, copy) NSString *releaseDateGte;
@property (nonatomic, copy) NSString *releaseDateLTE;
// 1-6
@property (nonatomic, assign) NSInteger withReleaseType;
@property (nonatomic, assign) NSInteger year;

@property (nonatomic, copy) NSString *voteCountGte;
@property (nonatomic, copy) NSString *voteCountLTE;
@property (nonatomic, copy) NSString *voteAverageGte;
@property (nonatomic, copy) NSString *voteAverageLTE;
// 逗号,分割
@property (nonatomic, copy) NSString *withCast;
@property (nonatomic, copy) NSString *withCrew;
@property (nonatomic, copy) NSString *withPeople;
@property (nonatomic, copy) NSString *withCompanies;
@property (nonatomic, copy) NSString *withGenres;
@property (nonatomic, copy) NSString *withoutGenres;
@property (nonatomic, copy) NSString *withKeywords;
@property (nonatomic, copy) NSString *withoutKeywords;
@property (nonatomic, copy) NSString *withRuntimeGte;
@property (nonatomic, copy) NSString *withRuntimeLTE;
@property (nonatomic, copy) NSString *withOriginalLanguage;
@property (nonatomic, copy) NSString *withWatchProviders;
@property (nonatomic, copy) NSString *watchRegion;
@property (nonatomic, copy) NSString *withWatchMonetizationTypes;
@property (nonatomic, copy) NSString *withoutCompanies;

// local
@property (nonatomic, assign) GZEMovieDiscoverySortType sortType;
@property (nonatomic, assign) GZEMovieDiscoveryWatchMonetizationType watchMonetizationType;
@end

NS_ASSUME_NONNULL_END
