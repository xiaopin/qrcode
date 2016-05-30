//
//  UIViewController+StatusBar.m
//  ScanQRCode
//
//  Created by nhope on 16/5/30.
//
//  统一设置状态栏的样式

#import "UIViewController+StatusBar.h"
#import <objc/runtime.h>

@implementation UIViewController (StatusBar)

#pragma mark - Lifecycle

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([UIViewController class], @selector(preferredStatusBarStyle));
        Method swizzledMethod = class_getInstanceMethod([UIViewController class], @selector(pc_preferredStatusBarStyle));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}


#pragma mark - Private

- (UIStatusBarStyle)pc_preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
