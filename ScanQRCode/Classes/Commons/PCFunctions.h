//
//  PCFunctions.h
//  ScanQRCode
//
//  Created by xiaopin on 16/5/14.
//
//  公共函数库

#import <UIKit/UIKit.h>

/**
 *  显示弹窗信息
 *
 *  @param title   标题
 *  @param msg     消息内容
 *  @param actions 自定义按钮数组,为空则自动添加一个OK按钮
 */
UIKIT_EXTERN void alertMessage(NSString *title, NSString *msg, NSArray<UIAlertAction *> *actions);


/**
 *  显示弹窗信息,样式为UIAlertControllerStyleActionSheet
 *
 *  @param title   标题
 *  @param msg     消息内容
 *  @param actions 自定义按钮数组,为空则自动添加一个OK按钮
 */
UIKIT_EXTERN void alertMessageSheet(NSString *title, NSString *msg, NSArray<UIAlertAction *> *actions);

/**
 *  从UIStoryboard中通过标识符加载控制器
 *
 *  @param storyboardName UIStoryboard名称,默认从Main.storyboard中加载
 *  @param identifier     控制器标识符
 *
 *  @return 对应的控制器
 */
UIKIT_EXTERN UIViewController* loadViewControllerFromStoryboard(NSString *storyboardName, NSString *identifier);
