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

@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *sortBy;
@property (nonatomic, copy) NSString *airDateGte;
@property (nonatomic, copy) NSString *airDateLTE;
@property (nonatomic, copy) NSString *firstAirDateGte;
@property (nonatomic, copy) NSString *firstAirDateLTE;
// NSInteger
@property (nonatomic, strong) NSNumber *firstAirDateYear;
// NSInteger
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, copy) NSString *timezone;
// Number, min=0
@property (nonatomic, strong) NSNumber *voteAverageGte;
// NSInteger, min=0
@property (nonatomic, strong) NSNumber *voteCountGte;
@property (nonatomic, copy) NSString *withGenres;
@property (nonatomic, copy) NSString *withNetworks;
@property (nonatomic, copy) NSString *withoutGenres;
// NSInteger
@property (nonatomic, strong) NSNumber *withRuntimeGte;
// NSInteger
@property (nonatomic, strong) NSNumber *withRuntimeLTE;
// Bool
@property (nonatomic, strong) NSNumber *includeNullFirstAirDates;
@property (nonatomic, copy) NSString *withOriginalLanguage;
@property (nonatomic, copy) NSString *withoutKeywords;
// Bool
@property (nonatomic, strong) NSNumber *screenedTheatrically;
@property (nonatomic, copy) NSString *withCompanies;
@property (nonatomic, copy) NSString *withKeywords;
@property (nonatomic, copy) NSString *withWatchProviders;
@property (nonatomic, copy) NSString *watchRegion;
@property (nonatomic, copy) NSString *withWatchMonetizationTypes;
// NSInteger 0-5
@property (nonatomic, strong) NSNumber *withStatus;
// NSInteger 0-6
@property (nonatomic, strong) NSNumber *withType;
@property (nonatomic, copy) NSString *withoutCompanies;

// local
@property (nonatomic, assign) GZETVDiscoverySortType sortType;
@property (nonatomic, assign) GZEMediaWatchMonetizationType watchMonetizationType;
@property (nonatomic, assign) GZETVDiscoveryType type;
@property (nonatomic, assign) GZETVDiscoveryStatus status;

@end

NS_ASSUME_NONNULL_END
