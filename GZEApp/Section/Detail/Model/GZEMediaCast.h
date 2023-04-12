//
//  GZEMediaCast.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEMediaCast : GZEBaseModel

@property (nonatomic, assign)           BOOL isAdult;
@property (nonatomic, nullable, copy)   NSString *backdropPath;
@property (nonatomic, copy)             NSArray<NSNumber *> *genreIDS;
@property (nonatomic, assign)           NSInteger identifier;
@property (nonatomic, copy)             NSString *originalLanguage;
@property (nonatomic, nullable, copy)   NSString *originalTitle;
@property (nonatomic, copy)             NSString *overview;
@property (nonatomic, assign)           double popularity;
@property (nonatomic, nullable, copy)   NSString *posterPath;
@property (nonatomic, nullable, copy)   NSString *releaseDate;
@property (nonatomic, nullable, copy)   NSString *title;
@property (nonatomic, nullable, strong) NSNumber *video;
@property (nonatomic, assign)           double voteAverage;
@property (nonatomic, assign)           NSInteger voteCount;
@property (nonatomic, copy)             NSString *character;
@property (nonatomic, copy)             NSString *creditID;
@property (nonatomic, nullable, strong) NSNumber *order;
@property (nonatomic, copy)             NSString *mediaType;
@property (nonatomic, nullable, copy)   NSArray<NSString *> *originCountry;
@property (nonatomic, nullable, copy)   NSString *originalName;
@property (nonatomic, nullable, copy)   NSString *firstAirDate;
@property (nonatomic, nullable, copy)   NSString *name;
@property (nonatomic, nullable, strong) NSNumber *episodeCount;

@end

NS_ASSUME_NONNULL_END
