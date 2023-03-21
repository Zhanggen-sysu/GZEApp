//
//  GZEMovieDiscoveryReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZEBaseReq.h"
#import "GZEEnum.h"

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
// BOOL
@property (nonatomic, strong) NSNumber *includeAdult;
// BOOL
@property (nonatomic, strong) NSNumber *includeVideo;
// NSInteger, 1-1000
@property (nonatomic, strong) NSNumber *page;
// NSInteger
@property (nonatomic, strong) NSNumber *primaryReleaseYear;
// 示例：2011-01-01
@property (nonatomic, copy) NSString *primaryReleaseDateGte;
@property (nonatomic, copy) NSString *primaryReleaseDateLTE;
@property (nonatomic, copy) NSString *releaseDateGte;
@property (nonatomic, copy) NSString *releaseDateLTE;
// 1-6, NSInteger
@property (nonatomic, strong) NSNumber *withReleaseType;
// NSInteger
@property (nonatomic, strong) NSNumber *year;

// NSInteger, min=0
@property (nonatomic, strong) NSNumber *voteCountGte;
// NSInteger, min=1
@property (nonatomic, strong) NSNumber *voteCountLTE;
// NSInteger, min=0
@property (nonatomic, strong) NSNumber *voteAverageGte;
// NSInteger, min=0
@property (nonatomic, strong) NSNumber *voteAverageLTE;
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
@property (nonatomic, assign) GZEMediaWatchMonetizationType watchMonetizationType;
@end

NS_ASSUME_NONNULL_END
