//
//  GZEPeopleDetailViewModel.m
//  GZEApp
//
//  Created by GenZhang on 2023/12/5.
//

#import "GZEPeopleDetailViewModel.h"
#import "GZEPeopleDetailReq.h"
#import "GZEPeopleDetailRsp.h"
#import "GZEPeopleDetailViewVM.h"

@interface GZEPeopleDetailViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *reqCommand;
@property (nonatomic, strong, readwrite) RACSubject *reloadSubject;
@property (nonatomic, strong, readwrite) GZEPeopleDetailViewVM *detailViewVM;

@end


@implementation GZEPeopleDetailViewModel

- (instancetype)init
{
    if (self = [super init]) {
        WeakSelf(self)
        self.reqCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber*  _Nullable peopleId) {
            StrongSelf(self)
            WeakSelf(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                StrongSelf(self)
                GZEPeopleDetailReq *req = [[GZEPeopleDetailReq alloc] init];
                req.peopleId = peopleId.integerValue;
                req.language = @"";
                req.type = GZEPeopleDetailType_All;
                req.page = 1;
                WeakSelf(self)
                [req startRequestWithRspClass:[GZEPeopleDetailRsp class]
                                completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
                    StrongSelfReturnNil(self)
                    if (isSuccess) {
                        self.detailViewVM = [[GZEPeopleDetailViewVM alloc] initWithModel:rsp];
                        
                        [self.reloadSubject sendNext:nil];
                        [subscriber sendNext:nil];
                    } else {
                        [subscriber sendNext:errorMessage];
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
        self.reloadSubject = [RACSubject subject];
    };
    return self;
}


@end
