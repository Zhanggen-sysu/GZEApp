//
//  GZEMovieListReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZEMovieListReq.h"

@implementation GZEMovieListReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"language": @"language",
        @"region": @"region",
        @"page": @"page",
    };
}

- (NSString *)requestUrl
{
    NSMutableString *url = [[NSMutableString alloc] initWithString:@"movie/"];
    switch (self.type) {
        case GZEMovieListType_Playing:
            [url appendString:@"now_playing"];
            break;
        case GZEMovieListType_Popular:
            [url appendString:@"popular"];
            break;
        case GZEMovieListType_TopRate:
            [url appendString:@"top_rated"];
            break;
        case GZEMovieListType_Upcoming:
            [url appendString:@"upcoming"];
            break;
            
        default:
            break;
    }
    return url;
}


@end
