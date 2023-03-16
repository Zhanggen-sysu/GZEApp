//
//  GZECustomButton.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/15.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GZEBtnImgPosition) {
    GZEBtnImgPosition_Left,
    GZEBtnImgPosition_Right,
    GZEBtnImgPosition_Top,
    GZEBtnImgPosition_Bottom,
};

typedef NS_ENUM(NSUInteger, GZEBtnContentAlign) {
    GZEBtnContentAlign_Left,
    GZEBtnContentAlign_Right,
    GZEBtnContentAlign_Top,
    GZEBtnContentAlign_Bottom,
    GZEBtnContentAlign_Center,
};

NS_ASSUME_NONNULL_BEGIN

// 图文位置自定义按钮
@interface GZECustomButton : UIButton
// 两个Size可以用CGSizeZero
@property (nonatomic, assign) CGSize titleSize;
@property (nonatomic, assign) CGSize imageSize;
// 图文间隔
@property (nonatomic, assign) CGFloat spacing;
// 图片位置
@property (nonatomic, assign) GZEBtnImgPosition imagePosition;
// 图文在按钮内的整体位置
@property (nonatomic, assign) GZEBtnContentAlign contentAlign;
// 图文在按钮内的整体偏移，比如GZEBtnContentAlign_Left，就是距离按钮左边距的距离，纵向居中，Center则忽略这个值
@property (nonatomic, assign) CGFloat contentOffset;

- (void)setImagePosition:(GZEBtnImgPosition)imagePosition
                 spacing:(CGFloat)spacing
            contentAlign:(GZEBtnContentAlign)contentAlign
           contentOffset:(CGFloat)contentOffset
               imageSize:(CGSize)imageSize
               titleSize:(CGSize)titleSize;

@end

NS_ASSUME_NONNULL_END
