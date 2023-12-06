//
//  GZEPeopleDetailViewVM.m
//  GZEApp
//
//  Created by GenZhang on 2023/12/6.
//

#import "GZEPeopleDetailViewVM.h"
#import "GZEPeopleDetailRsp.h"
#import "GZECommonHelper.h"

@interface GZEPeopleDetailViewVM ()

@property (nonatomic, strong) NSURL *profileUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *biography;

@end

@implementation GZEPeopleDetailViewVM

- (instancetype)initWithModel:(GZEPeopleDetailRsp *)model
{
    if (self = [super init]) {
        self.profileUrl = [GZECommonHelper getProfileUrl:model.profilePath size:GZEProfileSize_h632];
        NSMutableString *name = [[NSMutableString alloc] initWithString:model.name];
        [model.alsoKnownAs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([GZECommonHelper isChinese:obj isContain:YES]) {
                [name appendFormat:@" (%@)", obj];
                *stop = YES;
            }
        }];
        self.name = name;
        NSMutableString *detail = [[NSMutableString alloc] initWithFormat:@"Department: %@", model.knownForDepartment];
        if (model.placeOfBirth.length > 0) {
            [detail appendFormat:@"\nBirthplace: %@", model.placeOfBirth];
        }
        if (model.birthday.length > 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy"];
            NSInteger beginYear = [model.birthday substringToIndex:4].integerValue;
            NSInteger endYear = model.deathday.length > 0 ? [model.deathday substringToIndex:4].integerValue : [formatter stringFromDate:[NSDate date]].integerValue;
            [detail appendFormat:@"\nAge: %@ ~ %@, %ld years old", model.birthday, model.deathday.length > 0 ? model.deathday : @"Now", endYear - beginYear];
        }

        self.detail = detail;
        self.biography = model.biography;
    }
    return self;
}

@end
