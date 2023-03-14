//
//  GZECompanyListReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZECompanyListReq.h"

@implementation GZECompanyListReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"language": @"language",
        @"watch_region": @"watch_region",
    };
}

- (NSString *)requestUrl
{
    NSMutableString *url = [[NSMutableString alloc] initWithString:@"watch/providers/"];
    switch (self.type) {
        case GZECompanyListType_Movie:
            [url appendString:@"movie"];
            break;
        case GZECompanyListType_Tv:
            [url appendString:@"tv"];
            break;
        default:
            break;
    }
    return url;
}

@end
