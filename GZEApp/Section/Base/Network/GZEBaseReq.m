//
//  GZEBaseReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/1.
//

#import "GZEBaseReq.h"
#import "Macro.h"
#import "NSObject+YYModel.h"

@implementation GZEBaseReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    NSAssert(NO, @"Must override");
    return nil;
}

- (NSDictionary *)jsonDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:[self class].properties.allValues] mutableCopy];

    for (id jsonName in [self class].properties) {
        id propertyName = [self class].properties[jsonName];
        if (!dict[propertyName] || [dict[propertyName] isEqual:[NSNull null]]) {
            [dict removeObjectForKey:propertyName];
            continue;
        }
//        if (![dict[propertyName] isKindOfClass:[NSString class]]) {
//            NSAssert(NO, @"property value should be NSString class");
//        }
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }
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
