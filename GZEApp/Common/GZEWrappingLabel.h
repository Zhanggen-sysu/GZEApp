//
//  GZEWrappingLabel.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 利用CoreText实现的支持收起展开的Label，不过收起展开按钮暂时只支持自定义文案，不能添加图片
// 宽度不要用autolayout，不然可能会出问题，特别是tableview reload cell的时候，会新创建一个cell，导致没宽度，或为320
@interface GZEWrappingLabel : UIView

// 收起时的行数限制
@property (nonatomic, assign) NSInteger wrapNumberOfLine;
// 当前是否已经展开
@property (nonatomic, assign) BOOL isExpand;
// 初始化后，expandText设置为空，就全部绘制，wrapText设置为空就只展开不收起
@property (nonatomic, copy, nullable) NSAttributedString *wrapText;
@property (nonatomic, copy, nullable) NSAttributedString *expandText;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, copy) void (^didChangeHeight)(BOOL isExpand);

@end

NS_ASSUME_NONNULL_END
