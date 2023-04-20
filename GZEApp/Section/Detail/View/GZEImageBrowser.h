//
//  GZEImageBrowser.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/13.
//

#import <UIKit/UIKit.h>
@class GZEImageBrowser;

NS_ASSUME_NONNULL_BEGIN

@protocol GZEImageBrowserDelegate <NSObject>

- (NSInteger)getImageBrowserCount:(GZEImageBrowser *)browser;
- (NSString *)imageBrowser:(GZEImageBrowser *)browser imageUrlAtIndex:(NSInteger)idx;
- (UIImage *)imageBrowser:(GZEImageBrowser *)browser defaultImageAtIndex:(NSInteger)idx;

@optional
- (double)imageAspectRatioAtIndex:(NSInteger)idx;

@end

@interface GZEImageBrowser : UIView

@property (nonatomic, weak) id<GZEImageBrowserDelegate> delegate;

- (instancetype)initWithIndex:(NSInteger)index openFrame:(CGRect)openFrame;

- (void)show;
- (void)showInView:(UIView *)view;
- (void)close;

@end

NS_ASSUME_NONNULL_END
