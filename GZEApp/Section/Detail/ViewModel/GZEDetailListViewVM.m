//
//  GZEDetailListViewVM.m
//  GZEApp
//
//  Created by GenZhang on 2023/12/8.
//

#import "GZEDetailListViewVM.h"
#import "GZEMovieListRsp.h"
#import "GZETVListRsp.h"
#import "GZECombinedCreditsRsp.h"
#import "GZEDetailListCellVM.h"

@interface GZEDetailListViewVM ()

@property (nonatomic, copy, readwrite) NSArray *listArray;
@property (nonatomic, strong, readwrite) UIColor *magicColor;

@end

@implementation GZEDetailListViewVM

- (instancetype)initWithMovieListRsp:(GZEMovieListRsp *)model
                          magicColor:(UIColor *)magicColor
{
    if (self = [super init]) {
        // MARK: rac数组映射
        self.listArray = [[model.results.rac_sequence map:^id _Nullable(GZEMovieListItem * _Nullable value) {
            return [[GZEDetailListCellVM alloc] initWithMovieListItem:value magicColor:magicColor];
        }] array];
        self.magicColor = magicColor;
    }
    return self;
}

- (instancetype)initWithTvListRsp:(GZETVListRsp *)model
                       magicColor:(UIColor *)magicColor
{
    if (self = [super init]) {
        self.listArray = [[model.results.rac_sequence map:^id _Nullable(GZETVListItem * _Nullable value) {
            return [[GZEDetailListCellVM alloc] initWithTVListItem:value magicColor:magicColor];
        }] array];
        self.magicColor = magicColor;
    }
    return self;
}

@end
