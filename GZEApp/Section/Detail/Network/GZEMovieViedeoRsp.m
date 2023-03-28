//
//  GZEMovieViedeoRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "GZEMovieViedeoRsp.h"
#import "GZEMovieVideoItem.h"

@implementation GZEMovieViedeoRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"results": @"results",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"results": [GZEMovieVideoItem class],
    };
}
@end
