//
//  GZEProductionCountry.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEProductionCountry : GZEBaseModel

@property (nonatomic, copy) NSString *iso3166_1;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
