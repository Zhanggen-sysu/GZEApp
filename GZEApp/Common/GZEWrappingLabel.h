//
//  GZEWrappingLabel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 利用CoreText实现的支持收起展开的Label，不过收起展开按钮暂时只支持自定义文案，不能添加图片
@interface GZEWrappingLabel : UIView

// 收起时的行数限制
@property (nonatomic, assign) NSInteger wrapNumberOfLine;
// 当前是否已经展开
@property (nonatomic, assign) BOOL isWrap;
// 初始化后，expandText设置为空，就全部绘制，wrapText设置为空就只展开不收起
@property (nonatomic, copy, nullable) NSAttributedString *wrapText;
@property (nonatomic, copy, nullable) NSAttributedString *expandText;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, copy) void (^didChangeHeight)(BOOL isWrap);

@end

NS_ASSUME_NONNULL_END
