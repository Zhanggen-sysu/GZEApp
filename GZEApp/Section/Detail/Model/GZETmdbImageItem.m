//
//  GZETmdbImageItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZETmdbImageItem.h"

@implementation GZETmdbImageItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"aspect_ratio": @"aspectRatio",
        @"file_path": @"filePath",
        @"height": @"height",
        @"iso_639_1": @"iso639_1",
        @"vote_average": @"voteAverage",
        @"vote_count": @"voteCount",
        @"width": @"width",
    };
}

@end
