//
//  GZEMovieDetailRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
@class GZEGenreItem;
@class GZEProductionCompany;
@class GZEProductionCountry;
@class GZELanguageItem;
@class GZECollectionItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieDetailRsp : GZEBaseModel

@property (nonatomic, assign)         BOOL isAdult;
@property (nonatomic, copy)           NSString *backdropPath;
@property (nonatomic, nullable, copy) NSArray<GZECollectionItem *> *belongsToCollection;
@property (nonatomic, assign)         NSInteger budget;
@property (nonatomic, copy)           NSArray<GZEGenreItem *> *genres;
@property (nonatomic, copy)           NSString *homepage;
@property (nonatomic, assign)         NSInteger identifier;
@property (nonatomic, copy)           NSString *imdbID;
@property (nonatomic, copy)           NSString *originalLanguage;
@property (nonatomic, copy)           NSString *originalTitle;
@property (nonatomic, copy)           NSString *overview;
@property (nonatomic, assign)         double popularity;
@property (nonatomic, nullable, copy) NSString *posterPath;
@property (nonatomic, copy)           NSArray<GZEProductionCompany *> *productionCompanies;
@property (nonatomic, copy)           NSArray<GZEProductionCountry *> *productionCountries;
@property (nonatomic, copy)           NSString *releaseDate;
@property (nonatomic, assign)         NSInteger revenue;
@property (nonatomic, assign)         NSInteger runtime;
@property (nonatomic, copy)           NSArray<GZELanguageItem *> *spokenLanguages;
@property (nonatomic, copy)           NSString *status;
@property (nonatomic, copy)           NSString *tagline;
@property (nonatomic, copy)           NSString *title;
@property (nonatomic, assign)         BOOL isVideo;
@property (nonatomic, assign)         double voteAverage;
@property (nonatomic, assign)         NSInteger voteCount;

@end

NS_ASSUME_NONNULL_END
