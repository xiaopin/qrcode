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
void alertMessage(NSString *title, NSString *msg, NSArray<UIAlertAction *> *actions);
