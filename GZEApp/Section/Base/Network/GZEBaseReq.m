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
    NSString *assert = [NSString stringWithFormat:@"Must override %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    NSAssert(NO, assert);
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
        if (!dict[obj] || [dict[obj] isEqual:[NSNull null]]) {
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
        // 请求回来是字典，直接转模型
        if ([request.responseObject isKindOfClass:[NSDictionary class]]) {
            if ([rspClass respondsToSelector:@selector(yy_modelWithJSON:)]) {
                rsp = [rspClass yy_modelWithJSON:request.responseString];
            }
        }
        // 请求回来是数组，先给数组加个key：results，然后再转模型，在rsp中需要添加results属性，
        // 并实现modelContainerPropertyGenericClass，具体见GZELanguageListRsp
        if ([request.responseObject isKindOfClass:[NSArray class]]) {
            if ([rspClass respondsToSelector:@selector(yy_modelWithJSON:)]) {
                NSString *str = [[NSString alloc] initWithFormat:@"{\"results\":%@}", request.responseString];
                rsp = [rspClass yy_modelWithJSON:str];
            }
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
