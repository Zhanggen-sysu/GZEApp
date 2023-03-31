//
//  GZEGenreListReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEGenreListReq.h"

@implementation GZEGenreListReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"language": @"language",
    };
}

- (NSString *)requestUrl
{
    NSMutableString *url = [[NSMutableString alloc] initWithString:@"genre/"];
    switch (self.type) {
        case GZEMediaType_TV:
            [url appendString:@"tv/list"];
            break;
        case GZEMediaType_Movie:
            [url appendString:@"movie/list"];
            break;
        default:
            break;
    }
    return url;
}

@end
