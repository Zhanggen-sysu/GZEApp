//
//  GZELanguageListRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/21.
//

#import "GZELanguageListRsp.h"
#import "GZELanguageItem.h"

@implementation GZELanguageListRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"results": @"results",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"results": [GZELanguageItem class],
    };
}

@end
