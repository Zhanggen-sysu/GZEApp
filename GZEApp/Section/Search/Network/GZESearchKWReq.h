//
//  GZESearchKWReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/9/25.
//

#import "GZEBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZESearchKWReq : GZEBaseReq

@property (nonatomic, copy) NSString *query;
@property (nonatomic, assign) NSInteger page;

@end

NS_ASSUME_NONNULL_END
