//
//  GZEBaseModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/1.
//

#import "GZEBaseModel.h"
#import "NSObject+YYModel.h"

@interface GZEBaseModel () <YYModel>

@end

@implementation GZEBaseModel

+ (NSDictionary<NSString *, NSString *> *)properties
{
    NSAssert(NO, @"Must override");
    return nil;
}

#pragma mark - YYModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [[self properties] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dict setObject:key forKey:obj];
    }];
    return dict;
}

@end
