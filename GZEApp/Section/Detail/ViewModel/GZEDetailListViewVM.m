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

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSArray *listArray;
@property (nonatomic, strong, readwrite) UIColor *magicColor;

@end

@implementation GZEDetailListViewVM

- (instancetype)initWithTitle:(NSString *)title
                 movieListRsp:(GZEMovieListRsp *)model
                   magicColor:(UIColor *)magicColor
{
    if (self = [super init]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        // MARK: rac数组映射
        [model.results.rac_sequence.signal subscribeNext:^(GZEMovieListItem * _Nullable x) {
            GZEDetailListCellVM *vm = [[GZEDetailListCellVM alloc] initWithMovieListItem:x magicColor:magicColor];
            [array addObject:vm];
        }];
        self.listArray = [[model.results.rac_sequence map:^id _Nullable(GZEMovieListItem * _Nullable value) {
            return [[GZEDetailListCellVM alloc] initWithMovieListItem:value magicColor:magicColor];
        }] array];
        self.magicColor = magicColor;
        self.title = title;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                    tvListRsp:(GZETVListRsp *)model
                   magicColor:(UIColor *)magicColor
{
    if (self = [super init]) {
        self.listArray = [[model.results.rac_sequence map:^id _Nullable(GZETVListItem * _Nullable value) {
            return [[GZEDetailListCellVM alloc] initWithTVListItem:value magicColor:magicColor];
        }] array];
        self.magicColor = magicColor;
        self.title = title;
    }
    return self;
}

@end
