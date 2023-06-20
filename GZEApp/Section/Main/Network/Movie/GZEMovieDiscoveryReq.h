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
@property (nonatomic, copy, nullable) NSString *language;
// ISO 3166-1 例如 CN
@property (nonatomic, copy, nullable) NSString *region;

@property (nonatomic, copy, nullable) NSString *sortBy;

// 分级信息，各国不一样，需要请求/certification/movie/list
@property (nonatomic, copy, nullable) NSString *certificationCountry;
// 下面三个字段需要指定certificationCountry
@property (nonatomic, copy, nullable) NSString *certification;
@property (nonatomic, copy, nullable) NSString *certificationLTE;
@property (nonatomic, copy, nullable) NSString *certificationGte;
// BOOL
@property (nonatomic, strong, nullable) NSNumber *includeAdult;
// BOOL
@property (nonatomic, strong, nullable) NSNumber *includeVideo;
// NSInteger, 1-1000
@property (nonatomic, strong, nullable) NSNumber *page;
// NSInteger
@property (nonatomic, strong, nullable) NSNumber *primaryReleaseYear;
// 示例：2011-01-01
@property (nonatomic, copy, nullable) NSString *primaryReleaseDateGte;
@property (nonatomic, copy, nullable) NSString *primaryReleaseDateLTE;
@property (nonatomic, copy, nullable) NSString *releaseDateGte;
@property (nonatomic, copy, nullable) NSString *releaseDateLTE;
// 1-6, NSInteger
@property (nonatomic, strong, nullable) NSNumber *withReleaseType;
// NSInteger
@property (nonatomic, strong, nullable) NSNumber *year;

// NSInteger, min=0
@property (nonatomic, strong, nullable) NSNumber *voteCountGte;
// NSInteger, min=1
@property (nonatomic, strong, nullable) NSNumber *voteCountLTE;
// NSInteger, min=0
@property (nonatomic, strong, nullable) NSNumber *voteAverageGte;
// NSInteger, min=0
@property (nonatomic, strong, nullable) NSNumber *voteAverageLTE;
// 逗号,分割
@property (nonatomic, copy, nullable) NSString *withCast;
@property (nonatomic, copy, nullable) NSString *withCrew;
@property (nonatomic, copy, nullable) NSString *withPeople;
@property (nonatomic, copy, nullable) NSString *withCompanies;
@property (nonatomic, copy, nullable) NSString *withGenres;
@property (nonatomic, copy, nullable) NSString *withoutGenres;
@property (nonatomic, copy, nullable) NSString *withKeywords;
@property (nonatomic, copy, nullable) NSString *withoutKeywords;
@property (nonatomic, copy, nullable) NSNumber *withRuntimeGte;
@property (nonatomic, copy, nullable) NSNumber *withRuntimeLTE;
@property (nonatomic, copy, nullable) NSString *withOriginalLanguage;
@property (nonatomic, copy, nullable) NSString *withWatchProviders;
@property (nonatomic, copy, nullable) NSString *watchRegion;
@property (nonatomic, copy, nullable) NSString *withWatchMonetizationTypes;
@property (nonatomic, copy, nullable) NSString *withoutCompanies;

// local
@property (nonatomic, assign) GZEMovieDiscoverySortType sortType;
@property (nonatomic, assign) GZEMediaWatchMonetizationType watchMonetizationType;
@end

NS_ASSUME_NONNULL_END
