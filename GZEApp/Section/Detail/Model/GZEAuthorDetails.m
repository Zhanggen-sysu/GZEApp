//
//  GZEAuthorDetails.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEAuthorDetails.h"

@implementation GZEAuthorDetails

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"name": @"name",
        @"username": @"username",
        @"avatar_path": @"avatarPath",
        @"rating": @"rating",
    };
}

@end
