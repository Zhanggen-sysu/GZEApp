//
//  GZEGlobalConfig.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import <Foundation/Foundation.h>
@class GZEGenreItem;
NS_ASSUME_NONNULL_BEGIN

@interface GZEGlobalConfig : NSObject

+ (GZEGlobalConfig *)shareConfig;
// 语言
+ (NSString *)language;

// 获取类型列表
- (void)getGenresWithCompletion:(void (^)(NSArray<GZEGenreItem *> *))completion;

@end

NS_ASSUME_NONNULL_END
