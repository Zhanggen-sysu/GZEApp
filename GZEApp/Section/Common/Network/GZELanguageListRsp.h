//
//  GZELanguageListRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/21.
//

#import "GZEBaseModel.h"
@class GZELanguageItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZELanguageListRsp : GZEBaseModel

@property (nonatomic, copy) NSArray<GZELanguageItem *> *results;

@end

NS_ASSUME_NONNULL_END
