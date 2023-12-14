//
//  GZEGlobalConfig.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GZEEnum.h"
@class GZEGenreItem;
@class GZELanguageItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZEGlobalConfig : NSObject

@property (nonatomic, copy, readonly) NSDictionary<NSNumber *, NSString *> *genresDict;
@property (nonatomic, copy, readonly) NSDictionary<NSNumber *, NSString *> *tvGenresDict;
@property (nonatomic, strong) UIColor *magicColor;

+ (GZEGlobalConfig *)shareConfig;

// 语言
+ (NSString *)language;

// 获取类型列表
- (void)getGenresWithType:(GZEMediaType)mediaType completion:(nullable void (^)(NSDictionary<NSNumber *, NSString *> *))completion;

// 获取语言列表
- (void)getAllLanguagesWithCompletion:(nullable void (^)(NSDictionary<NSString *, GZELanguageItem *> *))completion;

- (NSArray<NSString *> *)supportLanguages;

- (NSInteger)currentYear;
- (NSInteger)currentMonth;
- (NSInteger)currentDay;
- (NSInteger)currentHour;
- (NSInteger)currentMinute;
- (NSInteger)currentSecond;

@end

NS_ASSUME_NONNULL_END
