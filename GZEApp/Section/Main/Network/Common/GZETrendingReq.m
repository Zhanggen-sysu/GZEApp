//
//  GZETrendingReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZETrendingReq.h"

@implementation GZETrendingReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
    };
}

- (NSString *)requestUrl
{
    NSMutableString *url = [[NSMutableString alloc] initWithString:@"trending/"];
    switch (self.mediaType) {
        case GZEMediaType_All:
            [url appendString:@"all"];
            break;
        case GZEMediaType_Movie:
            [url appendString:@"movie"];
            break;
        case GZEMediaType_TV:
            [url appendString:@"tv"];
            break;
        case GZEMediaType_Person:
            [url appendString:@"person"];
            break;
        default:
            break;
    }
    switch (self.timeWindow) {
        case GZETimeWindow_Day:
            [url appendString:@"/day"];
            break;
        case GZETimeWindow_Week:
            [url appendString:@"/week"];
            break;
        default:
            break;
    }
    return url;
}

@end
