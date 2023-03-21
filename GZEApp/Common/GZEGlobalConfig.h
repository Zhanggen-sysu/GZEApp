//
//  GZEGlobalConfig.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import <Foundation/Foundation.h>
#import "GZEEnum.h"
@class GZEGenreItem;
@class GZELanguageItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZEGlobalConfig : NSObject

@property (nonatomic, copy, readonly) NSDictionary<NSNumber *, NSString *> *genresDict;
@property (nonatomic, copy, readonly) NSDictionary<NSNumber *, NSString *> *tvGenresDict;

+ (GZEGlobalConfig *)shareConfig;
// 语言
+ (NSString *)language;

// 获取类型列表
- (void)getGenresWithType:(GZEMediaType)mediaType completion:(nullable void (^)(NSDictionary<NSNumber *, NSString *> *))completion;

- (void)getAllLanguagesWithCompletion:(nullable void (^)(NSDictionary<NSString *, GZELanguageItem *> *))completion;

- (NSArray<NSString *> *)supportLanguages;

@end

NS_ASSUME_NONNULL_END
