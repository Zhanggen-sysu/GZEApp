//
//  GZECastViewVM.m
//  GZEApp
//
//  Created by GenZhang on 2023/12/28.
//

#import "GZECastViewVM.h"
#import "GZECastItem.h"
#import "GZECrewCastRsp.h"

@interface GZECastViewVM ()

@property (nonatomic, copy, readwrite) NSArray *castArray;
@property (nonatomic, copy, readwrite) NSString *director;

@end

@implementation GZECastViewVM

- (instancetype)initWithCrewCastRsp:(GZECrewCastRsp *)rsp
                         magicColor:(UIColor *)magicColor
{
    if (self = [super init]) {
        self.castArray = [[rsp.cast.rac_sequence map:^id _Nullable(GZECastItem * _Nullable value) {
            value.magicColor = magicColor;
            return value;
        }] array];
        self.director = rsp.director;
    }
    return self;
}

@end
