//
//  GZETVDiscoveryReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/16.
//

#import "GZETVDiscoveryReq.h"

@implementation GZETVDiscoveryReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"language": @"language",
        @"sort_by": @"sortBy",
        @"air_date.gte": @"airDateGte",
        @"air_date.lte": @"airDateLTE",
        @"first_air_date.gte": @"firstAirDateGte",
        @"first_air_date.lte": @"firstAirDateLTE",
        @"first_air_date_year": @"firstAirDateYear",
        @"page": @"page",
        @"timezone": @"timezone",
        @"vote_average.gte": @"voteAverageGte",
        @"vote_count.gte": @"voteCountGte",
        @"with_genres": @"withGenres",
        @"with_networks": @"withNetworks",
        @"without_genres": @"withoutGenres",
        @"with_runtime.gte": @"withRuntimeGte",
        @"with_runtime.lte": @"withRuntimeLTE",
        @"include_null_first_air_dates": @"includeNullFirstAirDates",
        @"with_original_language": @"withOriginalLanguage",
        @"without_keywords": @"withoutKeywords",
        @"screened_theatrically": @"screenedTheatrically",
        @"with_companies": @"withCompanies",
        @"with_keywords": @"withKeywords",
        @"with_watch_providers": @"withWatchProviders",
        @"watch_region": @"watchRegion",
        @"with_watch_monetization_types": @"withWatchMonetizationTypes",
        @"with_status": @"withStatus",
        @"with_type": @"withType",
        @"without_companies": @"withoutCompanies",
    };
}

- (NSString *)requestUrl
{
    return @"discover/tv";
}

- (void)setSortType:(GZETVDiscoverySortType)sortType
{
    _sortType = sortType;
    switch (sortType) {
        case GZETVDiscoverySortType_PopularityDesc:
            _sortBy = @"popularity.desc";
            break;
        case GZETVDiscoverySortType_PopularityAsc:
            _sortBy = @"popularity.asc";
            break;
        case GZETVDiscoverySortType_FirstAirDateDesc:
            _sortBy = @"first_air_date.desc";
            break;
        case GZETVDiscoverySortType_FirstAirDateAsc:
            _sortBy = @"first_air_date.asc";
            break;
        case GZETVDiscoverySortType_VoteAverageDesc:
            _sortBy = @"vote_average.desc";
            break;
        case GZETVDiscoverySortType_VoteAverageAsc:
            _sortBy = @"vote_average.asc";
            break;
        default:
            break;
    }
}

- (void)setWatchMonetizationType:(GZEMediaWatchMonetizationType)watchMonetizationType
{
    _watchMonetizationType = watchMonetizationType;
    switch (watchMonetizationType) {
        case GZEMediaWatchMonetizationType_Flatrate:
            _withWatchMonetizationTypes = @"flatrate";
            break;
        case GZEMediaWatchMonetizationType_Free:
            _withWatchMonetizationTypes = @"free";
            break;
        case GZEMediaWatchMonetizationType_Ads:
            _withWatchMonetizationTypes = @"ads";
            break;
        case GZEMediaWatchMonetizationType_Rent:
            _withWatchMonetizationTypes = @"rent";
            break;
        case GZEMediaWatchMonetizationType_Buy:
            _withWatchMonetizationTypes = @"buy";
            break;
            
        default:
            break;
    }
}

- (void)setType:(GZETVDiscoveryType)type
{
    _type = type;
    self.withType = @(type);
}

- (void)setStatus:(GZETVDiscoveryStatus)status
{
    _status = status;
    self.withStatus = @(status);
}

@end
