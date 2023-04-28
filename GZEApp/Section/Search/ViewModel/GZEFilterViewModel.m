//
//  GZEFilterViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEFilterViewModel.h"
#import "GZEGlobalConfig.h"

@implementation GZEFilterModel


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
        GZEFilterModel *model = [[GZEFilterModel alloc] init];
        model.filterType = GZEFilterType_MediaType;
        model.title = @"Media Type";
        model.array = @[@"Movie", @"TV"];
        [mutableArray addObject:model];
    }
    if (filterTypes & GZEFilterType_Language) {
        GZEFilterModel *model = [[GZEFilterModel alloc] init];
        model.filterType = GZEFilterType_Language;
        model.title = @"Language";
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            [[GZEGlobalConfig shareConfig] getAllLanguagesWithCompletion:^(NSDictionary<NSString *,GZELanguageItem *> * _Nonnull languages) {
                [mutableArray addObject:model];
            }];
        });
    }
}

@end
