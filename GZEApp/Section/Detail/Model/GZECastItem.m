//
//  GZECastItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZECastItem.h"
#import "GZERoleItem.h"

@implementation GZECastItem

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"adult": @"isAdult",
        @"gender": @"gender",
        @"id": @"identifier",
        @"known_for_department": @"knownForDepartment",
        @"name": @"name",
        @"original_name": @"originalName",
        @"popularity": @"popularity",
        @"profile_path": @"profilePath",
        @"cast_id": @"castID",
        @"character": @"character",
        @"credit_id": @"creditID",
        @"order": @"order",
        @"roles": @"roles",
        @"total_episode_count": @"totalEpisodeCount",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"roles": [GZERoleItem class],
    };
}

@end
