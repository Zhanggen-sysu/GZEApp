//
//  GZETVDiscoveryReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/16.
//

#import "GZEBaseReq.h"
#import "GZEEnum.h"

typedef NS_ENUM(NSUInteger, GZETVDiscoverySortType) {
    GZETVDiscoverySortType_Default,
    GZETVDiscoverySortType_PopularityDesc,
    GZETVDiscoverySortType_PopularityAsc,
    GZETVDiscoverySortType_VoteAverageDesc,
    GZETVDiscoverySortType_VoteAverageAsc,
    GZETVDiscoverySortType_FirstAirDateDesc,
    GZETVDiscoverySortType_FirstAirDateAsc,
};

typedef NS_ENUM(NSUInteger, GZETVDiscoveryStatus) {
    GZETVDiscoveryStatus_Series,
    GZETVDiscoveryStatus_Planned,
    GZETVDiscoveryStatus_InProduction,
    GZETVDiscoveryStatus_Ended,
    GZETVDiscoveryStatus_Cancelled,
    GZETVDiscoveryStatus_Pilot,
};

typedef NS_ENUM(NSUInteger, GZETVDiscoveryType) {
    GZETVDiscoveryType_Documentary,
    GZETVDiscoveryType_News,
    GZETVDiscoveryType_Miniseries,
    GZETVDiscoveryType_Reality,
    GZETVDiscoveryType_Scripted,
    GZETVDiscoveryType_TalkShow,
    GZETVDiscoveryType_Video,
};

NS_ASSUME_NONNULL_BEGIN

@interface GZETVDiscoveryReq : GZEBaseReq

@property (nonatomic, copy, nullable) NSString *language;
@property (nonatomic, copy, nullable) NSString *sortBy;
@property (nonatomic, copy, nullable) NSString *airDateGte;
@property (nonatomic, copy, nullable) NSString *airDateLTE;
@property (nonatomic, copy, nullable) NSString *firstAirDateGte;
@property (nonatomic, copy, nullable) NSString *firstAirDateLTE;
// NSInteger
@property (nonatomic, strong, nullable) NSNumber *firstAirDateYear;
// NSInteger
@property (nonatomic, strong, nullable) NSNumber *page;
@property (nonatomic, copy, nullable) NSString *timezone;
// Number, min=0
@property (nonatomic, strong, nullable) NSNumber *voteAverageGte;
// NSInteger, min=0
@property (nonatomic, strong, nullable) NSNumber *voteCountGte;
@property (nonatomic, copy, nullable) NSString *withGenres;
@property (nonatomic, copy, nullable) NSString *withNetworks;
@property (nonatomic, copy, nullable) NSString *withoutGenres;
// NSInteger
@property (nonatomic, strong, nullable) NSNumber *withRuntimeGte;
// NSInteger
@property (nonatomic, strong, nullable) NSNumber *withRuntimeLTE;
// Bool
@property (nonatomic, strong, nullable) NSNumber *includeNullFirstAirDates;
@property (nonatomic, copy, nullable) NSString *withOriginalLanguage;
@property (nonatomic, copy, nullable) NSString *withoutKeywords;
// Bool
@property (nonatomic, strong, nullable) NSNumber *screenedTheatrically;
@property (nonatomic, copy, nullable) NSString *withCompanies;
@property (nonatomic, copy, nullable) NSString *withKeywords;
@property (nonatomic, copy, nullable) NSString *withWatchProviders;
@property (nonatomic, copy, nullable) NSString *watchRegion;
@property (nonatomic, copy, nullable) NSString *withWatchMonetizationTypes;
// NSInteger 0-5
@property (nonatomic, strong, nullable) NSNumber *withStatus;
// NSInteger 0-6
@property (nonatomic, strong, nullable) NSNumber *withType;
@property (nonatomic, copy, nullable) NSString *withoutCompanies;

// local
@property (nonatomic, assign) GZETVDiscoverySortType sortType;
@property (nonatomic, assign) GZEMediaWatchMonetizationType watchMonetizationType;
@property (nonatomic, assign) GZETVDiscoveryType type;
@property (nonatomic, assign) GZETVDiscoveryStatus status;

@end

NS_ASSUME_NONNULL_END
