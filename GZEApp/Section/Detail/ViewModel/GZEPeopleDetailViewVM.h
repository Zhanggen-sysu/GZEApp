//
//  GZEPeopleDetailViewVM.h
//  GZEApp
//
//  Created by GenZhang on 2023/12/6.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class GZEPeopleDetailRsp;

@interface GZEPeopleDetailViewVM : GZEBaseModel

@property (nonatomic, strong, readonly) NSURL *profileUrl;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *detail;
@property (nonatomic, copy, readonly) NSString *biography;

- (instancetype)initWithModel:(GZEPeopleDetailRsp *)model;

@end

NS_ASSUME_NONNULL_END
