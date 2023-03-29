//
//  GZEYTVideoReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEYTVideoReq.h"

@implementation GZEYTVideoReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
    };
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:@"https://noembed.com/embed?url=https://www.youtube.com/watch?v=%@", self.v];
}

@end
