//
//  GZEPeopleDetailReq.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEPeopleDetailReq.h"

@implementation GZEPeopleDetailReq

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"language": @"language",
        @"append_to_response": @"append_to_response",
        @"page": @"page",
    };
}

- (void)setType:(GZEPeopleDetailType)type
{
    _type = type;
    if (type == GZEPeopleDetailType_All) {
        self.append_to_response = @"combined_credits,images,tagged_images";
    }
}

- (NSString *)requestUrl
{
    NSMutableString *url = [[NSMutableString alloc] init];
    [url appendFormat:@"person/%@", @(self.peopleId)];
    switch (self.type) {
        case GZEPeopleDetailType_Default:
            NSAssert(NO, @"Must choose one type");
            break;
        case GZEPeopleDetailType_Credits:
            [url appendString:@"/combined_credits"];
            break;
        case GZEPeopleDetailType_Images:
            [url appendString:@"/images"];
            break;
        case GZEPeopleDetailType_TagImage:
            [url appendString:@"/tagged_images"];
            break;
        default:
            break;
    }
    return url;
}

@end
