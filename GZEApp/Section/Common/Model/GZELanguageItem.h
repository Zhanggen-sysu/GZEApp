//
//  GZELanguageItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/16.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZELanguageItem : GZEBaseModel

@property (nonatomic, copy) NSString *iso639_1;
@property (nonatomic, copy) NSString *englishName;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
