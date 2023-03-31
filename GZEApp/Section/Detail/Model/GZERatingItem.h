//
//  GZERatingItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZERatingItem : GZEBaseModel

@property (nonatomic, copy) NSArray<NSString *> *descriptors;
@property (nonatomic, copy) NSString *iso3166_1;
@property (nonatomic, copy) NSString *rating;

@end

NS_ASSUME_NONNULL_END
