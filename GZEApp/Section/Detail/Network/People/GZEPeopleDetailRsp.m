//
//  GZEPeopleDetailRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEPeopleDetailRsp.h"

@implementation GZEPeopleDetailRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"birthday": @"birthday",
        @"known_for_department": @"knownForDepartment",
        @"deathday": @"deathday",
        @"id": @"identifier",
        @"name": @"name",
        @"also_known_as": @"alsoKnownAs",
        @"gender": @"gender",
        @"biography": @"biography",
        @"popularity": @"popularity",
        @"place_of_birth": @"placeOfBirth",
        @"profile_path": @"profilePath",
        @"adult": @"isAdult",
        @"imdb_id": @"imdbID",
        @"homepage": @"homepage",
        @"combined_credits": @"combinedCredits",
        @"images": @"images",
        @"tagged_images": @"taggedImages",
    };
}

@end
