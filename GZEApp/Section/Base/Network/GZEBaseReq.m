//
//  GZEBaseReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/1.
//

#import "GZEBaseReq.h"
#import "Macro.h"
#import "NSObject+YYModel.h"
#import "GZEGlobalConfig.h"

@implementation GZEBaseReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    NSAssert(NO, @"Must override");
    return nil;
}

- (NSDictionary *)jsonDictionary
{
    NSMutableDictionary* dict = [[self dictionaryWithValuesForKeys:[self class].properties.allValues] mutableCopy];
    [[self class].properties enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"language"]) {
            // 修改下语言
            dict[obj] = [GZEGlobalConfig language];
        }
        if (!dict[obj] || [dict[obj] isEqual:[NSNull null]] || [dict[obj] isEqual:@(NO)] || [dict[obj] isEqual:@(0)]) {
            [dict removeObjectForKey:obj];
        } else if (![key isEqualToString:obj]) {
            dict[key] = dict[obj];
            [dict removeObjectForKey:obj];
        }
    }];
    [dict setObject:API_KEY forKey:@"api_key"];
    return dict;
}

- (id)requestArgument
{
    return [self jsonDictionary];
}

- (void)startRequestWithRspClass:(Class)rspClass
                   completeBlock:(GZECommonRspBlock)block
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        id rsp = nil;
        if ([rspClass respondsToSelector:@selector(yy_modelWithJSON:)]) {
            rsp = [rspClass yy_modelWithJSON:request.responseString];
        }
        if (rsp) {
            !block ?: block(YES, rsp, nil);
        } else {
            !block ?: block(NO, rsp, @"unable to convert model");
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !block ?: block(NO, nil, [request.responseObject objectForKey:@"status_message"]);
    }];
}

@end
