//
//  GZETVDetailReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZETVDetailReq.h"

@implementation GZETVDetailReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"language": @"language",
        @"append_to_response": @"append_to_response",
        @"page": @"page",
    };
}

- (void)setType:(GZETVDetailType)type
{
    _type = type;
    if (type == GZETVDetailType_All) {
        self.append_to_response = @"aggregate_credits,content_ratings,images,keywords,recommendations,reviews,similar,videos";
    }
}

- (NSString *)requestUrl
{
    NSMutableString *url = [[NSMutableString alloc] init];
    [url appendFormat:@"tv/%@", @(self.tvId)];
    switch (self.type) {
        case GZETVDetailType_Default:
            NSAssert(NO, @"Must choose one type");
            break;
        case GZETVDetailType_CrewCast:
            [url appendString:@"/aggregate_credits"];
            break;
        case GZETVDetailType_Rating:
            [url appendString:@"/content_ratings"];
            break;
        case GZETVDetailType_Image:
            [url appendString:@"/images"];
            break;
        case GZETVDetailType_Keyword:
            [url appendString:@"/keywords"];
            break;
        case GZETVDetailType_Recommend:
            [url appendString:@"/recommendations"];
            break;
        case GZETVDetailType_Review:
            [url appendString:@"/reviews"];
            break;
        case GZETVDetailType_Similar:
            [url appendString:@"/similar"];
            break;
        case GZETVDetailType_Videos:
            [url appendString:@"/videos"];
            break;
        default:
            break;
    }
    return url;
}

@end
