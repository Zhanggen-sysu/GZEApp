//
//  GZETmdbNetwork.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZETmdbNetwork : GZEBaseModel

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSString *logoPath;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *originCountry;

@end

NS_ASSUME_NONNULL_END
