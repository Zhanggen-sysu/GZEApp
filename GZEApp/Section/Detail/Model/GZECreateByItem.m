//
//  GZECreateByItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZECreateByItem.h"

@implementation GZECreateByItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"credit_id": @"creditID",
        @"name": @"name",
        @"gender": @"gender",
        @"profile_path": @"profilePath",
    };
}

@end
