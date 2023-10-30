//
//  MLeaksMessenger.m
//  MLeaksFinder
//
//  Created by 佘泽坡 on 7/17/16.
//  Copyright © 2016 zeposhe. All rights reserved.
//

#import "MLeaksMessenger.h"

static __weak UIAlertView *alertView;

static __weak UIAlertController *alertVC;

@implementation MLeaksMessenger

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    [self alertWithTitle:title message:message otherBlock:nil additionalButtonTitle:nil];
}

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
            otherBlock:(void (^)(void))otherBlock
 additionalButtonTitle:(NSString *)additionalButtonTitle {
    [alertVC dismissViewControllerAnimated:NO completion:nil];
    UIAlertController *alertVCTemp = [UIAlertController alertControllerWithTitle:title
                                                                         message:message
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertVCTemp addAction:okAction];
    if (additionalButtonTitle.length > 0) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:additionalButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            !otherBlock ?: otherBlock();
        }];
        [alertVCTemp addAction:otherAction];
    }
    UIViewController *presentVC = nil;
    if ([UIApplication sharedApplication].keyWindow.rootViewController) {
        presentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    } else {
        presentVC = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    }
    while (presentVC.presentedViewController) presentVC = presentVC.presentedViewController;
    [presentVC presentViewController:alertVCTemp animated:true completion:nil];
    alertVC = alertVCTemp;
    
    NSLog(@"%@: %@", title, message);
}

@end
