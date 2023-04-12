//
//  GZECommonHelper.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GZEDataType) {
    GZEDataType_default,
    GZEDataType_model,
    GZEDataType_array,
    GZEDataType_dictionary,
};

// 2 * 3
typedef NS_ENUM(NSUInteger, GZEPosterSize) {
    GZEPosterSize_default,
    GZEPosterSize_w92,
    GZEPosterSize_w154,
    GZEPosterSize_w185,
    GZEPosterSize_w342,
    GZEPosterSize_w500,
    GZEPosterSize_w780,
    GZEPosterSize_original,
};

// 16 * 9
typedef NS_ENUM(NSUInteger, GZEBackdropSize) {
    GZEBackdropSize_default,
    GZEBackdropSize_w300,
    GZEBackdropSize_w780,
    GZEBackdropSize_w1280,
    GZEBackdropSize_original,
};

// 约2 * 3，和poster一样
typedef NS_ENUM(NSUInteger, GZEProfileSize) {
    GZEProfileSize_default,
    GZEProfileSize_w45,
    GZEProfileSize_w185,
    GZEProfileSize_h632,
    GZEProfileSize_original,
};

// 1 * 1
typedef NS_ENUM(NSUInteger, GZELogoSize) {
    GZELogoSize_default,
    GZELogoSize_w45,
    GZELogoSize_w92,
    GZELogoSize_w154,
    GZELogoSize_w185,
    GZELogoSize_w300,
    GZELogoSize_w500,
    GZELogoSize_original,
};

@interface GZECommonHelper : NSObject

// 获取各类型图片URL
+ (NSURL *)getPosterUrl:(NSString *)string size:(GZEPosterSize)size;
+ (NSURL *)getBackdropUrl:(NSString *)string size:(GZEBackdropSize)size;
+ (NSURL *)getProfileUrl:(NSString *)string size:(GZEProfileSize)size;
+ (NSURL *)getLogoUrl:(NSString *)string size:(GZELogoSize)size;

// 提示
+ (void)showMessage:(NSString *)message inView:(nullable UIView *)view duration:(NSInteger)duration;
+ (UIWindow *)getKeyWindow;

// 圆角
+ (void)applyCornerRadiusToView:(UIView *)view radius:(CGFloat)radius corners:(UIRectCorner)corners;

// 通过评分生成五颗星星的评级字符串
+ (NSAttributedString *)generateRatingString:(double)voteAverage starSize:(CGFloat)size space:(NSInteger)space;

/// 颜色加深或减浅
/// - Parameters:
///   - color: 原始颜色
///   - deeper: YES加深 NO减浅
///   - degree: 变化程度，0-255
+ (UIColor *)changeColor:(UIColor *)color deeper:(BOOL)deeper degree:(NSUInteger)degree;

+ (NSString *)getNumberString:(NSInteger)number;

/// 判断是否是中文，或是否包含中文
/// - Parameters:
///   - str: 文本
///   - isContain: yes判断是否包含中文，no判断是否全是中文
+ (BOOL)isChinese:(NSString *)str isContain:(BOOL)isContain;

/// 持久存储
+ (void)setModel:(id)model withKey:(NSString *)key;
+ (id)getModel:(Class)aClass withKey:(NSString *)key dataType:(GZEDataType)dataType;

@end

NS_ASSUME_NONNULL_END
