//
//  GZETVDetailRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseModel.h"
@class GZECreateByItem;
@class GZEGenreItem;
@class GZEEpisodeToAir;
@class GZETmdbNetwork;
@class GZEProductionCompany;
@class GZEProductionCountry;
@class GZESeasonItem;
@class GZELanguageItem;

@class GZECrewCastRsp;
@class GZETVRatingRsp;
@class GZETmdbImageRsp;
@class GZEKeywordRsp;
@class GZETVListRsp;
@class GZETmdbReviewRsp;
@class GZETmdbVideoRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZETVDetailRsp : GZEBaseModel

@property (nonatomic, assign) BOOL isAdult;
@property (nonatomic, copy)   NSString *backdropPath;
@property (nonatomic, copy)   NSArray<GZECreateByItem *> *createdBy;
@property (nonatomic, copy)   NSArray<NSNumber *> *episodeRunTime;
@property (nonatomic, copy)   NSString *firstAirDate;
@property (nonatomic, copy)   NSArray<GZEGenreItem *> *genres;
@property (nonatomic, copy)   NSString *homepage;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) BOOL isInProduction;
@property (nonatomic, copy)   NSArray<NSString *> *languages;
@property (nonatomic, copy)   NSString *lastAirDate;
@property (nonatomic, strong) GZEEpisodeToAir *lastEpisodeToAir;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, strong) GZEEpisodeToAir *nextEpisodeToAir;
@property (nonatomic, copy)   NSArray<GZETmdbNetwork *> *networks;
@property (nonatomic, assign) NSInteger numberOfEpisodes;
@property (nonatomic, assign) NSInteger numberOfSeasons;
@property (nonatomic, copy)   NSArray<NSString *> *originCountry;
@property (nonatomic, copy)   NSString *originalLanguage;
@property (nonatomic, copy)   NSString *originalName;
@property (nonatomic, copy)   NSString *overview;
@property (nonatomic, assign) double popularity;
@property (nonatomic, copy)   NSString *posterPath;
@property (nonatomic, copy)   NSArray<GZEProductionCompany *> *productionCompanies;
@property (nonatomic, copy)   NSArray<GZEProductionCountry *> *productionCountries;
@property (nonatomic, copy)   NSArray<GZESeasonItem *> *seasons;
@property (nonatomic, copy)   NSArray<GZELanguageItem *> *spokenLanguages;
@property (nonatomic, copy)   NSString *status;
@property (nonatomic, copy)   NSString *tagline;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, assign) double voteAverage;
@property (nonatomic, assign) NSInteger voteCount;
// 全部放到一个请求返回
@property (nonatomic, strong) GZECrewCastRsp *aggregateCredits;
@property (nonatomic, strong) GZETVRatingRsp *contentRatings;
@property (nonatomic, strong) GZETmdbImageRsp *images;
@property (nonatomic, strong) GZEKeywordRsp *keywords;
@property (nonatomic, strong) GZETVListRsp *recommendations;
@property (nonatomic, strong) GZETmdbReviewRsp *reviews;
@property (nonatomic, strong) GZETVListRsp *similar;
@property (nonatomic, strong) GZETmdbVideoRsp *videos;
// Local
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, copy) NSString *countryText;
@property (nonatomic, copy) NSString *directorText;
@property (nonatomic, copy) NSString *subTitleText;
@property (nonatomic, copy) NSString *companyText;
@property (nonatomic, copy) NSString *networkText;

@end

NS_ASSUME_NONNULL_END
