//
//  GZEGenreItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEGenreItem : GZEBaseModel

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSString *name;

+ (GZEGenreItem *)itemWithId:(NSInteger)identifier name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
