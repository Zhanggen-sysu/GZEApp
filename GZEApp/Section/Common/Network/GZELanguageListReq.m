//
//  GZELanguageListReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/21.
//

#import "GZELanguageListReq.h"

@implementation GZELanguageListReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
    };
}

- (NSString *)requestUrl
{
    return @"configuration/languages";
}

@end
