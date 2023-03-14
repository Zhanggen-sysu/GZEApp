//
//  GZEMovieListRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZEBaseModel.h"

@class GZETmdbDate;
@class GZEMovieListItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieListRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy)   NSArray<GZEMovieListItem *> *results;
@property (nonatomic, strong) GZETmdbDate *dates;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalResults;

@end

NS_ASSUME_NONNULL_END
