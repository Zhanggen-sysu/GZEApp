//
//  GZEBaseReq.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/1.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^GZECommonRspBlock)(BOOL isSuccess, id _Nullable rsp, NSString * _Nullable errorMessage);
typedef void (^GZECommonNewRspBlock)(BOOL isSuccess, id _Nullable rsp, NSError *_Nullable error);

@interface GZEBaseReq : YTKBaseRequest

@property (nonatomic, assign) BOOL withoutApiKey;

- (NSDictionary *)jsonDictionary;

- (void)startRequestWithRspClass:(Class)rspClass
                   completeBlock:(GZECommonRspBlock)block;

- (void)startRequestWithRspClass:(Class)rspClass
          completeWithErrorBlock:(GZECommonNewRspBlock)block;

@end

NS_ASSUME_NONNULL_END
