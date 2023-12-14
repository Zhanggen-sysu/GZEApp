//
//  GZECrewCastRsp.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZECrewCastRsp.h"
#import "GZECastItem.h"
#import "GZECrewItem.h"

@implementation GZECrewCastRsp

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"cast": @"cast",
        @"crew": @"crew",
    };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
        @"cast": [GZECastItem class],
        @"crew": [GZECrewItem class],
    };
}

- (NSString *)director
{
    __block NSString *director = @"Unknown";
    [self.crew enumerateObjectsUsingBlock:^(GZECrewItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.job isEqualToString:@"Director"]) {
            director = obj.name;
            *stop = YES;
        }
    }];
    return director;
}

@end
