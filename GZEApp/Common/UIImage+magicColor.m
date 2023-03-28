//
//  UIImage+magicColor.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/28.
//

#import "UIImage+magicColor.h"

@implementation UIImage (magicColor)

- (UIColor *)magicColor
{
    return [UIImage getMagicColorByCompressedImg:self];
}

+ (UIImage *)compressImage:(UIImage *)image maxWidth:(NSUInteger)maxWidth
{
    //压缩图片
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    if (width < maxWidth) {
        return image;
    }
    NSUInteger sizeHeight = maxWidth * image.size.height / image.size.width;
    CGSize scaleSize = CGSizeMake(maxWidth, sizeHeight);
    UIGraphicsBeginImageContext(scaleSize);
    [image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

+ (unsigned char *)getRawDataFromImage:(UIImage *)image total:(NSUInteger *)total
{
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    *total = width * height;
    NSUInteger bytesPerPixel = 4;
    unsigned char *rawData = (unsigned char *)calloc(*total * bytesPerPixel, sizeof(unsigned char));

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bitsPerComponent = 8;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    return rawData;
}

+ (UIColor *)getMagicColorByCompressedImg:(UIImage *)image
{
    NSUInteger maxWidth = 64;
    UIImage *scaleImage = [UIImage compressImage:image maxWidth:maxWidth];
    //创建CGContextRef以供遍历

    NSUInteger bytesPerPixel = 4;
    NSUInteger total = 0;
    unsigned char *rawData = [UIImage getRawDataFromImage:scaleImage total:&total];

    NSUInteger red = 0;
    NSUInteger green = 0;
    NSUInteger blue = 0;
    NSUInteger alpha = 0;
    //遍历像素
    for (int i = 0; i < total; i++) {
        NSUInteger byteIndex = i * bytesPerPixel;
        unsigned char r = rawData[byteIndex];
        unsigned char g = rawData[byteIndex + 1];
        unsigned char b = rawData[byteIndex + 2];
        unsigned char a = rawData[byteIndex + 3];
        red += r;
        green += g;
        blue += b;
        alpha += a;
    }
    free(rawData);

    if (total > 0) {
        red /= total;
        green /= total;
        blue /= total;
        alpha /= total;
    }

    //最终输出颜色
    UIColor *outputColor = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 255.0];

    CGFloat colorHue;
    CGFloat colorSat;
    CGFloat colorBright;
    CGFloat colorAlpha;
    [outputColor getHue:&colorHue saturation:&colorSat brightness:&colorBright alpha:&colorAlpha];

    if (colorSat < 0.618) {
        CGFloat facotr = 0.618;
        colorSat = colorSat + (facotr - colorSat) * (1 - facotr);
    }

    if (colorBright > 0.618) {
        // 不能要太亮的
        colorBright *= 0.618;
    }

    //最终输出颜色
    outputColor = [UIColor colorWithHue:colorHue saturation:colorSat brightness:colorBright alpha:colorAlpha];
    return outputColor;
}

@end
