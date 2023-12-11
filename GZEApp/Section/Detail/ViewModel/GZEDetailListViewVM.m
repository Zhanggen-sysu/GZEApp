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
        [model.results enumerateObjectsUsingBlock:^(GZEMovieListItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GZEDetailListCellVM *vm = [[GZEDetailListCellVM alloc] initWithMovieListItem:obj magicColor:magicColor];
            [array addObject:vm];
        }];
        self.listArray = array;
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
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [model.results enumerateObjectsUsingBlock:^(GZETVListItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GZEDetailListCellVM *vm = [[GZEDetailListCellVM alloc] initWithTVListItem:obj magicColor:magicColor];
            [array addObject:vm];
        }];
        self.listArray = array;
        self.magicColor = magicColor;
        self.title = title;
    }
    return self;
}

@end
