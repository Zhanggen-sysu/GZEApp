//
//  GZEMovieDiscoveryReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZEMovieDiscoveryReq.h"

@implementation GZEMovieDiscoveryReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"language": @"language",
        @"region": @"region",
        @"sort_by": @"sortBy",
        @"certification_country": @"certificationCountry",
        @"certification": @"certification",
        @"certification.lte": @"certificationLTE",
        @"certification.gte": @"certificationGte",
        @"include_adult": @"includeAdult",
        @"include_video": @"includeVideo",
        @"page": @"page",
        @"primary_release_year": @"primaryReleaseYear",
        @"primary_release_date.gte": @"primaryReleaseDateGte",
        @"primary_release_date.lte": @"primaryReleaseDateLTE",
        @"release_date.gte": @"releaseDateGte",
        @"release_date.lte": @"releaseDateLTE",
        @"with_release_type": @"withReleaseType",
        @"year": @"year",
        @"vote_count.gte": @"voteCountGte",
        @"vote_count.lte": @"voteCountLTE",
        @"vote_average.gte": @"voteAverageGte",
        @"vote_average.lte": @"voteAverageLTE",
        @"with_cast": @"withCast",
        @"with_crew": @"withCrew",
        @"with_people": @"withPeople",
        @"with_companies": @"withCompanies",
        @"with_genres": @"withGenres",
        @"without_genres": @"withoutGenres",
        @"with_keywords": @"withKeywords",
        @"without_keywords": @"withoutKeywords",
        @"with_runtime.gte": @"withRuntimeGte",
        @"with_runtime.lte": @"withRuntimeLTE",
        @"with_original_language": @"withOriginalLanguage",
        @"with_watch_providers": @"withWatchProviders",
        @"watch_region": @"watchRegion",
        @"with_watch_monetization_types": @"withWatchMonetizationTypes",
        @"without_companies": @"withoutCompanies",
    };
}

- (NSString *)requestUrl
{
    return @"discover/movie";
}

- (void)setSortType:(GZEMovieDiscoverySortType)sortType
{
    _sortType = sortType;
    switch (sortType) {
        case GZEMovieDiscoverySortType_PopularityDesc:
            _sortBy = @"popularity_desc";
            break;
        case GZEMovieDiscoverySortType_PopularityAsc:
            _sortBy = @"popularity_asc";
            break;
        case GZEMovieDiscoverySortType_ReleaseDateDesc:
            _sortBy = @"release_date_desc";
            break;
        case GZEMovieDiscoverySortType_ReleaseDateAsc:
            _sortBy = @"release_date_asc";
            break;
        case GZEMovieDiscoverySortType_RevenueDesc:
            _sortBy = @"revenue_desc";
            break;
        case GZEMovieDiscoverySortType_RevenueAsc:
            _sortBy = @"revenue_asc";
            break;
        case GZEMovieDiscoverySortType_PrimaryReleaseDateDesc:
            _sortBy = @"primary_release_date_desc";
            break;
        case GZEMovieDiscoverySortType_PrimaryReleaseDateAsc:
            _sortBy = @"primary_release_date_asc";
            break;
        case GZEMovieDiscoverySortType_OriginalTitleDesc:
            _sortBy = @"original_title_desc";
            break;
        case GZEMovieDiscoverySortType_OriginalTitleAsc:
            _sortBy = @"original_title_asc";
            break;
        case GZEMovieDiscoverySortType_VoteAverageDesc:
            _sortBy = @"vote_average_desc";
            break;
        case GZEMovieDiscoverySortType_VoteAverageAsc:
            _sortBy = @"vote_average_asc";
            break;
        case GZEMovieDiscoverySortType_VoteCountDesc:
            _sortBy = @"vote_count_desc";
            break;
        case GZEMovieDiscoverySortType_VoteCountAsc:
            _sortBy = @"vote_count_asc";
            break;
        default:
            break;
    }
}

- (void)setWatchMonetizationType:(GZEMovieDiscoveryWatchMonetizationType)watchMonetizationType
{
    _watchMonetizationType = watchMonetizationType;
    switch (watchMonetizationType) {
        case GZEMovieDiscoveryWatchMonetizationType_Flatrate:
            _withWatchMonetizationTypes = @"flatrate";
            break;
        case GZEMovieDiscoveryWatchMonetizationType_Free:
            _withWatchMonetizationTypes = @"free";
            break;
        case GZEMovieDiscoveryWatchMonetizationType_Ads:
            _withWatchMonetizationTypes = @"ads";
            break;
        case GZEMovieDiscoveryWatchMonetizationType_Rent:
            _withWatchMonetizationTypes = @"rent";
            break;
        case GZEMovieDiscoveryWatchMonetizationType_Buy:
            _withWatchMonetizationTypes = @"buy";
            break;
            
        default:
            break;
    }
}

@end
