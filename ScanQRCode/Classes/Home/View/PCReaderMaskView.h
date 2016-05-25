//
//  PCReaderMaskView.h
//  ScanQRCode
//
//  Created by xiaopin on 16/5/13.
//
//  二维码扫描框视图

#import <UIKit/UIKit.h>

@interface PCReaderMaskView : UIView

/**
 *  扫描区域
 */
@property (nonatomic, assign) CGRect scanRect;

/**
 *  开启扫描动画
 *  必须调用stopScanLineAnimate关闭动画,否则导致内存泄漏
 */
- (void)startScanLineAnimate;
/**
 *  关闭扫描动画
 */
- (void)stopScanLineAnimate;

@end
