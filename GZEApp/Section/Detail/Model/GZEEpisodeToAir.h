//
//  GZEEpisodeToAir.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEEpisodeToAir : GZEBaseModel

@property (nonatomic, assign)         NSInteger identifier;
@property (nonatomic, copy)           NSString *name;
@property (nonatomic, copy)           NSString *overview;
@property (nonatomic, assign)         NSInteger voteAverage;
@property (nonatomic, assign)         NSInteger voteCount;
@property (nonatomic, copy)           NSString *airDate;
@property (nonatomic, assign)         NSInteger episodeNumber;
@property (nonatomic, copy)           NSString *productionCode;
@property (nonatomic, assign)         NSInteger runtime;
@property (nonatomic, assign)         NSInteger seasonNumber;
@property (nonatomic, assign)         NSInteger showID;
@property (nonatomic, nullable, copy) NSString *stillPath;

@end

NS_ASSUME_NONNULL_END
