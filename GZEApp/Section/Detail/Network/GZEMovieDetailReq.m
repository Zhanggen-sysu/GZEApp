//
//  GZEMovieDetailReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEMovieDetailReq.h"

@implementation GZEMovieDetailReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"language": @"language",
        @"append_to_response": @"append_to_response",
        @"include_image_language": @"include_image_language",
        @"page": @"page",
    };
}

- (NSString *)requestUrl
{
    NSMutableString *url = [[NSMutableString alloc] init];
    [url appendFormat:@"movie/%@", @(self.movieId)];
    switch (self.type) {
        case GZEMovieDetailType_Default:
            NSAssert(NO, @"Must choose one type");
            break;
        case GZEMovieDetailType_CrewCast:
            [url appendString:@"/credits"];
            break;
        case GZEMovieDetailType_Video:
            [url appendString:@"/videos"];
            break;
        case GZEMovieDetailType_Image:
            [url appendString:@"/images"];
            break;
        case GZEMovieDetailType_Review:
            [url appendString:@"/reviews"];
            break;
        case GZEMovieDetailType_Similar:
            [url appendString:@"/similar"];
            break;
        default:
            break;
    }
    return url;
}

@end
