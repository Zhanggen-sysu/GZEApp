//
//  GZEGenreListRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseModel.h"
@class GZEGenreItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZEGenreListRsp : GZEBaseModel

@property (nonatomic, copy) NSArray<GZEGenreItem *> *genres;

@end

NS_ASSUME_NONNULL_END
