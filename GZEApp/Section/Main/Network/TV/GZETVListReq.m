//
//  GZETVListReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZETVListReq.h"

@implementation GZETVListReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"language": @"language",
        @"page": @"page",
    };
}

- (NSString *)requestUrl
{
    NSMutableString *url = [[NSMutableString alloc] initWithString:@"tv/"];
    switch (self.type) {
        case GZETVListType_AiringToday:
            [url appendString:@"airing_today"];
            break;
        case GZETVListType_OnTheAir:
            [url appendString:@"on_the_air"];
            break;
        case GZETVListType_Popular:
            [url appendString:@"popular"];
            break;
        case GZETVListType_TopRated:
            [url appendString:@"top_rated"];
            break;
            
        default:
            break;
    }
    return url;
}

@end
