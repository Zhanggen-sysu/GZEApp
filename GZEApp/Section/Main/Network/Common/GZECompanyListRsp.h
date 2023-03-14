//
//  GZECompanyListRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZEBaseModel.h"
@class GZECompanyListItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZECompanyListRsp : GZEBaseModel

@property (nonatomic, copy) NSArray<GZECompanyListItem *> *results;

@end

NS_ASSUME_NONNULL_END
