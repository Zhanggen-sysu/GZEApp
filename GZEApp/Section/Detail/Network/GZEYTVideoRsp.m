//
//  GZEYTVideoRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEYTVideoRsp.h"

@implementation GZEYTVideoRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"thumbnail_width": @"thumbnailWidth",
        @"width": @"width",
        @"provider_name": @"providerName",
        @"type": @"type",
        @"height": @"height",
        @"provider_url": @"providerURL",
        @"html": @"html",
        @"author_url": @"authorURL",
        @"thumbnail_url": @"thumbnailURL",
        @"author_name": @"authorName",
        @"title": @"title",
        @"thumbnail_height": @"thumbnailHeight",
        @"version": @"version",
        @"url": @"url",
    };
}

@end
