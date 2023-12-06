//
//  GZEPeopleDetailViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/12/5.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GZEPeopleDetailViewVM;

@interface GZEPeopleDetailViewModel : GZEBaseModel

@property (nonatomic, strong, readonly) RACCommand *reqCommand;
@property (nonatomic, strong, readonly) RACSubject *reloadSubject;
@property (nonatomic, strong, readonly) GZEPeopleDetailViewVM *detailViewVM;

@end

NS_ASSUME_NONNULL_END
