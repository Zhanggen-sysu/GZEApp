//
//  GZEBaseDetailViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/12/13.
//

#import "GZEBaseDetailViewModel.h"
#import "GZEFilterViewModel.h"
#import "GZESearchResultVC.h"

@implementation GZEBaseDetailViewModel

- (instancetype)init
{
    if (self = [super init]) {
        WeakSelf(self)
        self.keywordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(GZEGenreItem * _Nullable input) {
            StrongSelf(self)
            GZEFilterViewModel *viewModel = [GZEFilterViewModel createFilterModelWithKeywords:@[input] mediaType:GZEMediaType_Movie];
            GZESearchResultVC *vc = [[GZESearchResultVC alloc] initWithViewModel:viewModel];
//            [[CYLTa] pushViewController:vc animated:YES];
            return [RACSignal empty];
        }];
    }
}

@end
