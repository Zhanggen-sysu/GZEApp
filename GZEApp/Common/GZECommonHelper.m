//
//  GZECommonHelper.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/2.
//

#import "GZECommonHelper.h"
#import "MBProgressHUD.h"
#import "Macro.h"

@implementation GZECommonHelper

+ (NSURL *)getPosterUrl:(NSString *)string size:(GZEPosterSize)size
{
    NSString *width = @"w342";
    switch (size) {
        case GZEPosterSize_w92:
            width = @"w92";
            break;
        case GZEPosterSize_w154:
            width = @"w154";
            break;
        case GZEPosterSize_w185:
            width = @"w185";
            break;
        case GZEPosterSize_w342:
            width = @"w342";
            break;
        case GZEPosterSize_w500:
            width = @"w500";
            break;
        case GZEPosterSize_w780:
            width = @"w780";
            break;
        case GZEPosterSize_original:
            width = @"original";
            break;
            
        default:
            break;
    }
    
    NSString *posterPath = [NSString stringWithFormat:@"%@%@%@", API_IMG_BASEURL, width, string];
    return [NSURL URLWithString:posterPath];
}

+ (NSURL *)getBackdropUrl:(NSString *)string size:(GZEBackdropSize)size
{
    NSString *width = @"w780";
    switch (size) {
        case GZEBackdropSize_w300:
            width = @"w300";
            break;
        case GZEBackdropSize_w780:
            width = @"w780";
            break;
        case GZEBackdropSize_w1280:
            width = @"w1280";
            break;
        case GZEPosterSize_original:
            width = @"original";
            break;
            
        default:
            break;
    }
    
    NSString *backdropPath = [NSString stringWithFormat:@"%@%@%@", API_IMG_BASEURL, width, string];
    return [NSURL URLWithString:backdropPath];
}

+ (NSURL *)getProfileUrl:(NSString *)string size:(GZEProfileSize)size
{
    NSString *width = @"w185";
    switch (size) {
        case GZEProfileSize_w45:
            width = @"w45";
            break;
        case GZEProfileSize_w185:
            width = @"w185";
            break;
        case GZEProfileSize_h632:
            width = @"h632";
            break;
        case GZEProfileSize_original:
            width = @"original";
            break;
            
        default:
            break;
    }
    
    NSString *profilePath = [NSString stringWithFormat:@"%@%@%@", API_IMG_BASEURL, width, string];
    return [NSURL URLWithString:profilePath];
}

+ (NSURL *)getLogoUrl:(NSString *)string size:(GZELogoSize)size
{
    NSString *width = @"w185";
    switch (size) {
        case GZELogoSize_w45:
            width = @"w45";
            break;
        case GZELogoSize_w92:
            width = @"w92";
            break;
        case GZELogoSize_w154:
            width = @"w154";
            break;
        case GZELogoSize_w185:
            width = @"w185";
            break;
        case GZELogoSize_w300:
            width = @"w300";
            break;
        case GZELogoSize_w500:
            width = @"w500";
            break;
        case GZELogoSize_original:
            width = @"original";
            break;
            
        default:
            break;
    }
    
    NSString *logoPath = [NSString stringWithFormat:@"%@%@%@", API_IMG_BASEURL, width, string];
    return [NSURL URLWithString:logoPath];
}

+ (UIWindow *)getKeyWindow
{
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    } else {
        window = [[UIApplication sharedApplication] keyWindow];
    }
    return window;
}

+ (void)showMessage:(NSString *)message inView:(nullable UIView *)view duration:(NSInteger)duration
{
    if (message.length <= 0) {
        return;
    }
    
    UIView *showView = view;
    if (!showView) {
        showView = [GZECommonHelper getKeyWindow];
    }
    [MBProgressHUD hideHUDForView:showView animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:duration];
}

+ (void)applyCornerRadiusToView:(UIView *)view radius:(CGFloat)radius corners:(UIRectCorner)corners
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = view.bounds;
    shapeLayer.path = path.CGPath;
    view.layer.mask = shapeLayer;
}

+ (NSAttributedString *)generateRatingString:(double)voteAverage starSize:(CGFloat)size space:(NSInteger)space
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    for (NSInteger i = 0; i < 5; i ++)
    {
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        if (voteAverage >= 2) {
            voteAverage -= 2;
            attach.image = [UIImage imageNamed:@"starFullIcon"];
        } else if (voteAverage >= 1) {
            voteAverage -= 1;
            attach.image = [UIImage imageNamed:@"starHalfIcon"];
        } else {
            attach.image = [UIImage imageNamed:@"starEmptyIcon"];
        }
        attach.bounds = CGRectMake(0, 0, size, size);
        [attStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[@"" stringByPaddingToLength:space withString:@" " startingAtIndex:0]]];
    }
    return attStr;
}

+ (UIColor *)changeColor:(UIColor *)color deeper:(BOOL)deeper degree:(NSUInteger)degree
{
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    red = red * 255;
    green = green * 255;
    blue = blue * 255;
    if (deeper) {
        red = red >= degree ? red - degree : 0;
        green = green >= degree ? green - degree : 0;
        blue = blue >= degree ? blue - degree : 0;
    } else {
        red = red + degree <= 255 ? red + degree : 255;
        green = green + degree <= 255 ? green + degree : 255;
        blue = blue + degree <= 255 ? blue + degree : 255;
    }
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1];
}

+ (NSString *)getNumberString:(NSInteger)number
{
    if (number >= 1000000000) {
        return [NSString stringWithFormat:@"%ldB", number / 1000000000];
    } else if (number >= 1000000) {
        return [NSString stringWithFormat:@"%ldM", number / 1000000];
    } else if (number >= 1000) {
        return [NSString stringWithFormat:@"%ldK", number / 1000];
    }
    return [NSString stringWithFormat:@"%ld", number];
}

@end
