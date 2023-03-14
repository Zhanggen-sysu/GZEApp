//
//  GZECompanyListRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZECompanyListRsp.h"
#import "GZECompanyListItem.h"

@implementation GZECompanyListRsp

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
        @"results": [GZECompanyListItem class],
    };
}

@end
