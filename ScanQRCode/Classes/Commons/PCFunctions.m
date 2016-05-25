//
//  PCFunctions.m
//  ScanQRCode
//
//  Created by xiaopin on 16/5/14.
//
//

#import "PCFunctions.h"


/**
 *  显示弹窗信息
 *
 *  @param title   标题
 *  @param msg     消息内容
 *  @param actions 自定义按钮数组,为空则自动添加一个OK按钮
 */
void alertMessage(NSString *title, NSString *msg, NSArray<UIAlertAction *> *actions)
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (actions.count > 0) {
        for (UIAlertAction *action in actions) {
            [alertController addAction:action];
        }
    } else {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
    }
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:alertController animated:YES completion:nil];
}
