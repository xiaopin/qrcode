//
//  PCScanOperationBar.h
//  ScanQRCode
//
//  Created by xiaopin on 16/5/14.
//
//  底部操作条

#import <UIKit/UIKit.h>

@class PCScanOperationBar;

@protocol PCScanOperationBarDelegate <NSObject>

@optional
- (void)scanOperationBar:(PCScanOperationBar * _Nullable)operationBar
   photoButtonDidClicked:(UIButton * _Nullable)button;

- (void)scanOperationBar:(PCScanOperationBar * _Nullable)operationBar
   flashButtonDidClicked:(UIButton * _Nullable)button;

- (void)scanOperationBar:(PCScanOperationBar * _Nullable)operationBar
    moreButtonDidClicked:(UIButton * _Nullable)button;

@end


@interface PCScanOperationBar : UIView

@property (nonatomic, weak, nullable) id<PCScanOperationBarDelegate> delegate;

@end
