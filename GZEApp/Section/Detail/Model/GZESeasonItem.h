//
//  GZESeasonItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZESeasonItem : GZEBaseModel

@property (nonatomic, copy)   NSString *airDate;
@property (nonatomic, assign) NSInteger episodeCount;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *overview;
@property (nonatomic, copy)   NSString *posterPath;
@property (nonatomic, assign) NSInteger seasonNumber;

@end

NS_ASSUME_NONNULL_END
