//
//  GZEBaseReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/1.
//

#import "YTKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^GZECommonRspBlock)(BOOL isSuccess, id _Nullable rsp, NSString * _Nullable errorMessage);

@interface GZEBaseReq : YTKBaseRequest

- (NSDictionary *)jsonDictionary;

- (void)startRequestWithRspClass:(Class)rspClass
                   completeBlock:(GZECommonRspBlock)block;

@end

NS_ASSUME_NONNULL_END
