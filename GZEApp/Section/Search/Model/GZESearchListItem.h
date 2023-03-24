//
//  GZESearchListItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import "GZEBaseModel.h"
@class GZETrendingItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZESearchListItem : GZEBaseModel

@property (nonatomic, nullable, copy)   NSString *posterPath;
@property (nonatomic, assign)           double popularity;
@property (nonatomic, assign)           NSInteger identifier;
@property (nonatomic, nullable, copy)   NSString *overview;
@property (nonatomic, nullable, copy)   NSString *backdropPath;
@property (nonatomic, assign)           double voteAverage;
@property (nonatomic, copy)             NSString *mediaType;
@property (nonatomic, nullable, copy)   NSString *firstAirDate;
@property (nonatomic, nullable, copy)   NSArray<NSString *> *originCountry;
@property (nonatomic, nullable, copy)   NSArray<NSNumber *> *genreIDS;
@property (nonatomic, nullable, copy)   NSString *originalLanguage;
@property (nonatomic, nullable, strong) NSNumber *voteCount;
@property (nonatomic, nullable, copy)   NSString *name;
@property (nonatomic, nullable, copy)   NSString *originalName;
@property (nonatomic, nullable, strong) NSNumber *adult;
@property (nonatomic, nullable, copy)   NSString *releaseDate;
@property (nonatomic, nullable, copy)   NSString *originalTitle;
@property (nonatomic, nullable, copy)   NSString *title;
@property (nonatomic, nullable, strong) NSNumber *video;
@property (nonatomic, nullable, copy)   NSString *profilePath;
// person独有
@property (nonatomic, nullable, copy)   NSArray<GZETrendingItem *> *knownFor;

@end

NS_ASSUME_NONNULL_END
