//
//  GZECrewItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZECrewItem.h"
#import "GZEJobItem.h"

@implementation GZECrewItem

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
        @"credit_id": @"creditID",
        @"department": @"department",
        @"job": @"job",
        @"jobs": @"jobs",
        @"total_episode_count": @"totalEpisodeCount",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"jobs": [GZEJobItem class],
    };
}

@end
