//
//  GZEBaseReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/1.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^GZECommonRspBlock)(BOOL isSuccess, id _Nullable rsp, NSString * _Nullable errorMessage);

@interface GZEBaseReq : YTKBaseRequest

@property (nonatomic, assign) BOOL withoutApiKey;

- (NSDictionary *)jsonDictionary;

- (void)startRequestWithRspClass:(Class)rspClass
                   completeBlock:(GZECommonRspBlock)block;

@end

NS_ASSUME_NONNULL_END
