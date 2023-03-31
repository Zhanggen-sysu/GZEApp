//
//  GZERoleItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZERoleItem : GZEBaseModel

@property (nonatomic, copy)   NSString *creditID;
@property (nonatomic, copy)   NSString *character;
@property (nonatomic, assign) NSInteger episodeCount;

@end

NS_ASSUME_NONNULL_END
