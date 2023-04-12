//
//  GZECombinedCreditsRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEBaseModel.h"
@class GZEMediaCast;
@class GZEMediaCrew;

NS_ASSUME_NONNULL_BEGIN

@interface GZECombinedCreditsRsp : GZEBaseModel

@property (nonatomic, copy) NSArray<GZEMediaCast *> *cast;
@property (nonatomic, copy) NSArray<GZEMediaCrew *> *crew;
@property (nonatomic, assign) NSInteger identifier;

@end

NS_ASSUME_NONNULL_END
