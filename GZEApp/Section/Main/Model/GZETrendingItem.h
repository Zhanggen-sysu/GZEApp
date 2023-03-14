//
//  GZETrendingItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZETrendingItem : GZEBaseModel

@property (nonatomic, assign)           BOOL isAdult;
@property (nonatomic, copy)             NSString *backdropPath;
@property (nonatomic, assign)           NSInteger identifier;
@property (nonatomic, nullable, copy)   NSString *title;
@property (nonatomic, copy)             NSString *originalLanguage;
@property (nonatomic, nullable, copy)   NSString *originalTitle;
@property (nonatomic, copy)             NSString *overview;
@property (nonatomic, copy)             NSString *posterPath;
@property (nonatomic, copy)             NSString *mediaType;
@property (nonatomic, copy)             NSArray<NSNumber *> *genreIDS;
@property (nonatomic, assign)           double popularity;
@property (nonatomic, nullable, copy)   NSString *releaseDate;
@property (nonatomic, nullable, strong) NSNumber *video;
@property (nonatomic, assign)           double voteAverage;
@property (nonatomic, assign)           NSInteger voteCount;
@property (nonatomic, nullable, copy)   NSString *name;
@property (nonatomic, nullable, copy)   NSString *originalName;
@property (nonatomic, nullable, copy)   NSString *firstAirDate;
@property (nonatomic, nullable, copy)   NSArray<NSString *> *originCountry;

@end

NS_ASSUME_NONNULL_END
