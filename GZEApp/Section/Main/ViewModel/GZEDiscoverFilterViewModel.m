//
//  GZEDiscoverFilterViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/17.
//

#import "GZEDiscoverFilterViewModel.h"
#import "GZELanguageItem.h"
#import "GZEGenreItem.h"
#import "GZEGlobalConfig.h"

static NSInteger kFilterItemCount = 100;

@implementation GZEDiscoverFilterItem

+ (GZEDiscoverFilterItem *)itemWithKey:(NSString *)key value:(NSString *)value
{
    GZEDiscoverFilterItem *model = [[GZEDiscoverFilterItem alloc] init];
    model.key = key;
    model.value = value;
    return model;
}

@end

@implementation GZEDiscoverFilterViewModel

+ (GZEDiscoverFilterViewModel *)viewModelWithLanguageDict:(NSDictionary<NSString *, GZELanguageItem *> *)languageDict mediaType:(GZEMediaType)mediaType
{
    GZEDiscoverFilterViewModel *viewModel = [[GZEDiscoverFilterViewModel alloc] init];
    viewModel.filterType = GZEDiscoverFilterType_Language;
    viewModel.mediaType = mediaType;
    viewModel.selectIndex = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[GZEDiscoverFilterItem itemWithKey:@"-1" value:@"All"]];
    [[[GZEGlobalConfig shareConfig] supportLanguages] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[GZEDiscoverFilterItem itemWithKey:obj value:languageDict[obj].englishName]];
    }];
    viewModel.itemArray = array;
    return viewModel;
}

+ (GZEDiscoverFilterViewModel *)viewModelWithGenreDict:(NSDictionary<NSNumber *, NSString *> *)genreDict mediaType:(GZEMediaType)mediaType
{
    GZEDiscoverFilterViewModel *viewModel = [[GZEDiscoverFilterViewModel alloc] init];
    viewModel.filterType = GZEDiscoverFilterType_Genre;
    viewModel.mediaType = mediaType;
    viewModel.selectIndex = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    GZEDiscoverFilterItem *item = [[GZEDiscoverFilterItem alloc] init];
    item.key = @"-1";
    item.value = @"All";
    [array addObject:item];
    __block NSInteger count = 1;
    [genreDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        GZEDiscoverFilterItem *item = [[GZEDiscoverFilterItem alloc] init];
        item.key = key.stringValue;
        item.value = obj;
        [array addObject:item];
        count ++;
        if (count >= kFilterItemCount) {
            *stop = YES;
        }
    }];
    viewModel.itemArray = array;
    return viewModel;
}

@end
