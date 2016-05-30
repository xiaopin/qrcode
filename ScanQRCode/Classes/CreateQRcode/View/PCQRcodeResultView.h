//
//  PCQRcodeResultView.h
//  ScanQRCode
//
//  Created by nhope on 16/5/30.
//
//

#import <UIKit/UIKit.h>

@class PCQRcodeResultView;

@protocol PCQRcodeResultViewDelegate <NSObject>

@optional
/**
 *  用户长按二维码图片的回调
 *
 *  @param view      PCQRcodeResultView
 *  @param image     二维码图片
 */
- (void)qrcodeResultView:(PCQRcodeResultView * _Nullable)view didLongPressQRcodeImage:(UIImage * _Nullable)image;

@end


@interface PCQRcodeResultView : UIView

@property (nonatomic, weak, nullable) id<PCQRcodeResultViewDelegate> delegate;

/**
 *  设置需要展示的二维码图片
 *
 *  @param qrimage 二维码图片
 */
- (void)setQRcodeImage:(UIImage * _Nonnull)qrimage;

@end
