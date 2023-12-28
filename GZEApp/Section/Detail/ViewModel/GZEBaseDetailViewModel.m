//
//  GZEBaseDetailViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/12/13.
//

#import "GZEBaseDetailViewModel.h"
#import "GZEFilterViewModel.h"
#import "GZECastItem.h"

#import "GZECommonHelper.h"

#import "GZESearchResultVC.h"
#import "GZEPeopleDetailVC.h"

@implementation GZEBaseDetailViewModel

- (instancetype)init
{
    if (self = [super init]) {
        WeakSelf(self)
        self.keywordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(GZEGenreItem *keyword) {
            StrongSelf(self)
            GZEFilterViewModel *viewModel = [GZEFilterViewModel createFilterModelWithKeywords:@[keyword] mediaType:GZEMediaType_Movie];
            GZESearchResultVC *vc = [[GZESearchResultVC alloc] initWithViewModel:viewModel];
            [[GZECommonHelper getMainNavigationController] pushViewController:vc animated:YES];
            return [RACSignal empty];
        }];
        
        self.peopleCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(GZECastItem *cast) {
            StrongSelf(self)
            GZEPeopleDetailVC *vc = [[GZEPeopleDetailVC alloc] initWithPeopleId:cast.identifier];
            [[GZECommonHelper getMainNavigationController] pushViewController:vc animated:YES];
            return [RACSignal empty];
        }];
    }
    return self;
}

@end
