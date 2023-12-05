//
//  GZEPeopleDetailViewModel.h
//  GZEApp
//
//  Created by GenZhang on 2023/12/5.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEPeopleDetailViewModel : GZEBaseModel

@property (nonatomic, strong, readonly) RACCommand *reqCommand;
@property (nonatomic, strong, readonly) RACSubject *reloadSubject;

@end

NS_ASSUME_NONNULL_END
