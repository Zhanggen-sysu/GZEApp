//
//  Macro.h
//  GZEApp
//
//  Created by GenZhang on 2023/2/28.
//

#ifndef Macro_h
#define Macro_h

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
// Screen Size
#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif

// Color

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// Image
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

// Cycle Retain
#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type) __strong typeof(type) type = weak##type;
#define StrongSelfReturnNil(type)  __strong typeof(type) type = weak##type;\
                                    if (!type)return;

// font
#define kFont(size) [UIFont systemFontOfSize:size]
#define kBoldFont(size) [UIFont boldSystemFontOfSize:size]

#define API_KEY @"748c16b2d0a067ab5e9055e41fc2754b"
#define API_IMG_BASEURL @"https://image.tmdb.org/t/p/"

#endif /* Macro_h */
