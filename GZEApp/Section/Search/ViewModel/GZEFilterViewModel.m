//
//  GZEFilterViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEFilterViewModel.h"
#import "GZEGlobalConfig.h"
#import "GZELanguageItem.h"
#import "Macro.h"

@implementation GZEFilterItem

+ (instancetype)itemWithKey:(NSString *)key value:(NSString *)value type:(GZEFilterType)type
{
    GZEFilterItem *item = [[GZEFilterItem alloc] init];
    item.key = key;
    item.value = value;
    item.type = type;
    return item;
}

@end

@implementation GZEFilterModel

+ (instancetype)modelWithTitle:(NSString *)title filterType:(GZEFilterType)filterType array:(NSArray<GZEFilterItem *> *)array selectIndex:(NSMutableArray *)selectIndexs allowMultiSelect:(BOOL)allowMultiSelect
{
    GZEFilterModel *model = [[GZEFilterModel alloc] init];
    model.title = title;
    model.filterType = filterType;
    model.array = array;
    model.selectIndexs = selectIndexs;
    model.allowMultiSelect = allowMultiSelect;
    return model;
}

+ (NSString *)getTextWithModel:(GZEFilterModel *)model
{
    NSMutableString *text = [[NSMutableString alloc] init];
    if (model.allowMultiSelect) {
        [model.selectIndexs enumerateObjectsUsingBlock:^(id  _Nonnull index, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *selectIndex = (NSNumber *)index;
            [text appendString:[NSString stringWithFormat:@"%@,", [model.array objectAtIndex:selectIndex.integerValue].key]];
        }];
        [text substringToIndex:text.length-2];
    } else {
        NSNumber *selectIndex = model.selectIndexs.firstObject;
        [text appendString:[model.array objectAtIndex:selectIndex.integerValue].key];
    }
    return text;
}

@end

@implementation GZEFilterViewModel

+ (void)createFilterModelWithType:(GZEFilterType)filterTypes completeBlock:(void (^)(GZEFilterViewModel *))completeBlock;
{
    GZEFilterViewModel *viewModel = [[GZEFilterViewModel alloc] init];
    viewModel.filterTypes = filterTypes;
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if (filterTypes & GZEFilterType_MediaType) {
        GZEFilterItem *tvItem = [GZEFilterItem itemWithKey:@"tv" value:@"TV" type:GZEFilterType_MediaType];
        GZEFilterItem *movieItem = [GZEFilterItem itemWithKey:@"movie" value:@"Movie" type:GZEFilterType_MediaType];
        [mutableArray addObject:[GZEFilterModel modelWithTitle:@"Media Type" filterType:GZEFilterType_MediaType array:@[movieItem, tvItem] selectIndex:[[NSMutableArray alloc] initWithObjects:@0, nil] allowMultiSelect:NO]];
    }
    if (filterTypes & GZEFilterType_Decade) {
        NSInteger currentDecade = [[GZEGlobalConfig shareConfig] currentYear] / 10 * 10;
        NSMutableArray *itemArray = [[NSMutableArray alloc] init];
        for (NSInteger decade = currentDecade; decade >= currentDecade - 100; decade -= 10) {
            [itemArray addObject:[GZEFilterItem itemWithKey:[NSString stringWithFormat:@"%ld", decade] value:[NSString stringWithFormat:@"%ld's", decade] type:GZEFilterType_Decade]];
        }
        [mutableArray addObject:[GZEFilterModel modelWithTitle:@"Decade" filterType:GZEFilterType_Decade array:itemArray selectIndex:[NSMutableArray new] allowMultiSelect:NO]];
    }
    if (filterTypes & GZEFilterType_Year) {
        NSInteger currentYear = [[GZEGlobalConfig shareConfig] currentYear];
        NSMutableArray *itemArray = [[NSMutableArray alloc] init];
        for (NSInteger year = currentYear; year >= currentYear - 100; year -= 1) {
            [itemArray addObject:[GZEFilterItem itemWithKey:[NSString stringWithFormat:@"%ld", year] value:[NSString stringWithFormat:@"%ld", year] type:GZEFilterType_Year]];
        }
        [mutableArray addObject:[GZEFilterModel modelWithTitle:@"Year" filterType:GZEFilterType_Year array:itemArray selectIndex:[NSMutableArray new] allowMultiSelect:NO]];
    }
    if (filterTypes & GZEFilterType_VoteAverage) {
        NSMutableArray *itemArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 9; i >= 5; i --) {
            [itemArray addObject:[GZEFilterItem itemWithKey:[NSString stringWithFormat:@"%ld", i] value:[NSString stringWithFormat:@"%ld+", i] type:GZEFilterType_VoteAverage]];
        }
        [mutableArray addObject:[GZEFilterModel modelWithTitle:@"Votes Rating" filterType:GZEFilterType_VoteAverage array:itemArray selectIndex:[NSMutableArray new] allowMultiSelect:NO]];
    }
    if (filterTypes & GZEFilterType_VoteCount) {
        NSMutableArray *itemArray = [[NSMutableArray alloc] init];
        NSArray *multipleBy = @[@(2.5), @(2), @(2)];
        NSInteger base = 1000, cnt = 3;
        while (cnt > 0) {
            NSInteger i = -1;
            do {
                [itemArray addObject:[GZEFilterItem itemWithKey:[NSString stringWithFormat:@"%ld", base] value:[NSString stringWithFormat:@"%ld+ votes", base] type:GZEFilterType_VoteCount]];
                i++;
                base *= [(NSNumber *)multipleBy[i] floatValue];
            } while (i < 2);
            cnt --;
        }
        [mutableArray addObject:[GZEFilterModel modelWithTitle:@"Total votes" filterType:GZEFilterType_VoteCount array:itemArray selectIndex:[NSMutableArray new] allowMultiSelect:NO]];
    }
    if (filterTypes & GZEFilterType_Runtime) {
        NSMutableArray *itemArray = [[NSMutableArray alloc] init];
        [itemArray addObject:[GZEFilterItem itemWithKey:@"30" value:@"30 min or less" type:GZEFilterType_Runtime]];
        [itemArray addObject:[GZEFilterItem itemWithKey:@"60" value:@"1 hour or less" type:GZEFilterType_Runtime]];
        [itemArray addObject:[GZEFilterItem itemWithKey:@"120" value:@"1 to 2 hours" type:GZEFilterType_Runtime]];
        [itemArray addObject:[GZEFilterItem itemWithKey:@"180" value:@"2 to 3 hours" type:GZEFilterType_Runtime]];
        [itemArray addObject:[GZEFilterItem itemWithKey:@"240" value:@"3 to 4 hours" type:GZEFilterType_Runtime]];
        [itemArray addObject:[GZEFilterItem itemWithKey:@"240+" value:@"Over 4 hours" type:GZEFilterType_Runtime]];
        [mutableArray addObject:[GZEFilterModel modelWithTitle:@"Runtime" filterType:GZEFilterType_Runtime array:itemArray selectIndex:nil allowMultiSelect:NO]];
    }
    if (filterTypes & GZEFilterType_Language) {
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            [[GZEGlobalConfig shareConfig] getAllLanguagesWithCompletion:^(NSDictionary<NSString *,GZELanguageItem *> * _Nonnull languages) {
                NSMutableArray *itemArray = [[NSMutableArray alloc] init];
                [languages enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, GZELanguageItem * _Nonnull obj, BOOL * _Nonnull stop) {
                    [itemArray addObject:[GZEFilterItem itemWithKey:key value:obj.englishName type:GZEFilterType_Language]];
                }];
                [mutableArray addObject:[GZEFilterModel modelWithTitle:@"Language" filterType:GZEFilterType_Language array:itemArray selectIndex:[NSMutableArray new] allowMultiSelect:YES]];
                dispatch_group_leave(group);
            }];
        });
    }
    if (filterTypes & GZEFilterType_Genre) {
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            [[GZEGlobalConfig shareConfig] getGenresWithType:GZEMediaType_Movie completion:^(NSDictionary<NSNumber *,NSString *> * _Nonnull genres) {
                NSMutableArray *itemArray = [[NSMutableArray alloc] init];
                [genres enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                    [itemArray addObject:[GZEFilterItem itemWithKey:key.stringValue value:obj type:GZEFilterType_Genre]];
                }];
                [mutableArray addObject:[GZEFilterModel modelWithTitle:@"Genres" filterType:GZEFilterType_Genre array:itemArray selectIndex:[NSMutableArray new] allowMultiSelect:YES]];
                dispatch_group_leave(group);
            }];
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        viewModel.filterArray = mutableArray;
        !completeBlock ?: completeBlock(viewModel);
    });
}


- (void)selectMediaType:(GZEMediaType)mediaType completeBlock:(void (^)(void))completeBlock
{
    [self.filterArray enumerateObjectsUsingBlock:^(GZEFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.filterType == GZEFilterType_Genre) {
            [[GZEGlobalConfig shareConfig] getGenresWithType:mediaType completion:^(NSDictionary<NSNumber *,NSString *> * _Nonnull genres) {
                NSMutableArray *itemArray = [[NSMutableArray alloc] init];
                [genres enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                    [itemArray addObject:[GZEFilterItem itemWithKey:key.stringValue value:obj type:GZEFilterType_Genre]];
                }];
                obj.array = itemArray;
                obj.selectIndexs = [NSMutableArray new];
                !completeBlock ?: completeBlock();
            }];
        }
    }];
}


@end
