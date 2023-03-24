//
//  GZESearchReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/24.
//

#import "GZEBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZESearchReq : GZEBaseReq

@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *query;
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *includeAdult;
@property (nonatomic, copy) NSString *region;

@end

NS_ASSUME_NONNULL_END
