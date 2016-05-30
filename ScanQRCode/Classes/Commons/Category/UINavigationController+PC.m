//
//  UINavigationController+PC.m
//  ScanQRCode
//
//  Created by nhope on 16/5/30.
//
//

#import "UINavigationController+PC.h"
#import <objc/runtime.h>

@implementation UINavigationController (PC)

#pragma mark - Lifecycle

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 设置导航栏样式
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        [navigationBar setTintColor:[UIColor whiteColor]];
        [navigationBar setBarTintColor:ColorWithRGB(39.0, 39.0, 39.0)];
        [navigationBar setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                                NSFontAttributeName : [UIFont systemFontOfSize:16.0]
                                                }];
        UIImage *backImage = [UIImage imageNamed:@"back"];
        [navigationBar setBackIndicatorImage:backImage];
        [navigationBar setBackIndicatorTransitionMaskImage:backImage];
        
        // 设置导航栏按钮样式
        UIBarButtonItem *globalBarButtonItem = [UIBarButtonItem appearance];
        [globalBarButtonItem setTitleTextAttributes:@{
                                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                                      NSFontAttributeName: [UIFont systemFontOfSize:14.0]
                                                      }
                                           forState:UIControlStateNormal];
        
        // 交换方法实现,在自定义方法中将返回按钮文字统一修改为"返回"
        Method originalMethod = class_getInstanceMethod([UINavigationController class], @selector(pushViewController:animated:));
        Method swizzledMethod = class_getInstanceMethod([UINavigationController class], @selector(pc_pushViewController:animated:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

#pragma mark - Private

- (void)pc_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    /**
     使用pushViewController切换到下一个视图时，UINavigationController按照以下3条顺序更改导航栏的左侧按钮:
     1、如果B视图有一个自定义的左侧按钮（leftBarButtonItem），则会显示这个自定义按钮
     2、如果B没有自定义按钮，但是A视图的backBarButtonItem属性有值，则显示这个自定义项
     3、如果前2条都没有，则默认显示一个后退按钮，后退按钮的标题是A视图的标题
     
     原文内容：
     The Left Item
     For all but the root view controller on the navigation stack, the item on the left side of the navigation bar provides navigation back to the previous view controller. The contents of this left-most button are determined as follows:
     
     If the new top-level view controller has a custom left bar button item, that item is displayed. To specify a custom left bar button item, set the leftBarButtonItem property of the view controller’s navigation item.
     
     If the top-level view controller does not have a custom left bar button item, but the navigation item of the previous view controller has an object in its backBarButtonItem property, the navigation bar displays that item.
     
     If a custom bar button item is not specified by either of the view controllers, a default back button is used and its title is set to the value of the title property of the previous view controller—that is, the view controller one level down on the stack. (If there is only one view controller on the navigation stack, no back button is displayed.)
     */
    if (self.childViewControllers.count > 0) {
        UIBarButtonItem *backItem =[[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:nil
                                                                   action:nil];
        [self.topViewController.navigationItem setBackBarButtonItem:backItem];
    }
    [self pc_pushViewController:viewController animated:animated];
}

#pragma mark - Screen Rotate & Status Style
/** 将屏幕旋转和状态栏样式的控制权转交给当前控制器 */

- (BOOL)shouldAutorotate {
    if (self.topViewController != nil) {
        return [self.topViewController shouldAutorotate];
    }
    return [super shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.topViewController != nil) {
        return [self.topViewController supportedInterfaceOrientations];
    }
    return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.topViewController != nil) {
        return [self.topViewController preferredInterfaceOrientationForPresentation];
    }
    return [super preferredInterfaceOrientationForPresentation];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController != nil) {
        return [self.topViewController preferredStatusBarStyle];
    }
    return [super preferredStatusBarStyle];
}

@end
