//
//  GZECrewItem.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZECrewItem.h"

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
    };
}

@end
