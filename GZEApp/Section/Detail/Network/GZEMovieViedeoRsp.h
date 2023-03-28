//
//  GZEMovieViedeoRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEBaseModel.h"
@class GZEMovieVideoItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZEMovieViedeoRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSArray<GZEMovieVideoItem *> *results;

@end

NS_ASSUME_NONNULL_END
