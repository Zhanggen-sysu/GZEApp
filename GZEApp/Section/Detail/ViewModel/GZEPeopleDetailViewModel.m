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

@property (nonatomic, assign, readwrite) NSInteger peopleId;

@property (nonatomic, strong, readwrite) RACCommand *reqCommand;
@property (nonatomic, strong, readwrite) RACSubject *reloadSubject;
@property (nonatomic, strong, readwrite) GZEPeopleDetailViewVM *detailViewVM;

@end


@implementation GZEPeopleDetailViewModel

- (instancetype)initWithPeopleId:(NSInteger)peopleId
{
    if (self = [super init]) {
        self.peopleId = peopleId;
        [self initializeRAC];
    };
    return self;
}

- (void)initializeRAC
{
    WeakSelf(self)
    self.reqCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber*  _Nullable peopleId) {
        StrongSelf(self)
        WeakSelf(self)
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            StrongSelf(self)
            GZEPeopleDetailReq *req = [[GZEPeopleDetailReq alloc] init];
            req.peopleId = self.peopleId;
            req.language = @"";
            req.type = GZEPeopleDetailType_All;
            req.page = 1;
            WeakSelf(self)
            [req startRequestWithRspClass:[GZEPeopleDetailRsp class]
                            completeBlock:^(BOOL isSuccess, id  _Nullable rsp, NSString * _Nullable errorMessage) {
                StrongSelfReturnNil(self)
                if (isSuccess) {
                    self.detailViewVM = [[GZEPeopleDetailViewVM alloc] initWithModel:rsp];
                    
                    [subscriber sendNext:nil];
                } else {
                    [subscriber sendNext:errorMessage];
                }
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
}


@end
