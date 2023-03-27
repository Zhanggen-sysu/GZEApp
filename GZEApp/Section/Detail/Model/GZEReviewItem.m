//
//  GZEReviewItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEReviewItem.h"

@implementation GZEReviewItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"author": @"author",
        @"author_details": @"authorDetails",
        @"content": @"content",
        @"created_at": @"createdAt",
        @"id": @"identifier",
        @"updated_at": @"updatedAt",
        @"url": @"url",
    };
}

@end
