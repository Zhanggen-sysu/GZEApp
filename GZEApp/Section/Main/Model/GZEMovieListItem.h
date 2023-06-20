//
//  GZEMovieListItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieListItem : GZEBaseModel

@property (nonatomic, copy)   NSString *posterPath;
@property (nonatomic, assign) BOOL isAdult;
@property (nonatomic, copy)   NSString *overview;
@property (nonatomic, copy)   NSString *releaseDate;
@property (nonatomic, copy)   NSArray<NSNumber *> *genreIDS;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSString *originalTitle;
@property (nonatomic, copy)   NSString *originalLanguage;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *backdropPath;
@property (nonatomic, assign) double popularity;
@property (nonatomic, assign) NSInteger voteCount;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, assign) double voteAverage;

// local, 文本是否展开
@property (nonatomic, assign) BOOL isExpand;

@end

NS_ASSUME_NONNULL_END
