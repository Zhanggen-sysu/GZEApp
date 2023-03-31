//
//  GZEJobItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEJobItem : GZEBaseModel

@property (nonatomic, copy)   NSString *creditID;
@property (nonatomic, copy)   NSString *job;
@property (nonatomic, assign) NSInteger episodeCount;

@end

NS_ASSUME_NONNULL_END
