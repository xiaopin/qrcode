//
//  PCScanOperationBar.m
//  ScanQRCode
//
//  Created by xiaopin on 16/5/14.
//
//

#import "PCScanOperationBar.h"

@interface PCScanOperationBar ()

/**
 *  读取相册按钮
 */
@property (nonatomic, strong, nullable) UIButton *photoButton;
/**
 *  闪光灯按钮
 */
@property (nonatomic, strong, nullable) UIButton *flashButton;
/**
 *  更多操作按钮
 */
@property (nonatomic, strong, nullable) UIButton *moreButton;

@end


@implementation PCScanOperationBar

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self addSubview:self.photoButton];
        [self addSubview:self.flashButton];
        [self addSubview:self.moreButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger buttonCount = self.subviews.count;
    CGFloat padding = (CGRectGetWidth(self.frame) - buttonCount * kScanOperationBarButtonWidth) / (buttonCount + 1);
    CGFloat y = (CGRectGetHeight(self.frame) - kScanOperationBarButtonHeight) / 2;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = (idx + 1) * padding + idx * kScanOperationBarButtonWidth;
        obj.frame = CGRectMake(x, y, kScanOperationBarButtonWidth, kScanOperationBarButtonHeight);
    }];
}

#pragma mark - Action

- (void)photoButtonAction:(UIButton *)button {
    SEL selector = @selector(scanOperationBar:photoButtonDidClicked:);
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate scanOperationBar:self
                  photoButtonDidClicked:button];
    }
}

- (void)flashButtonAction:(UIButton *)button {
    SEL selector = @selector(scanOperationBar:flashButtonDidClicked:);
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate scanOperationBar:self
                  flashButtonDidClicked:button];
    }
    button.selected = !button.selected;
}

- (void)moreButtonAction:(UIButton *)button {
    SEL selector = @selector(scanOperationBar:moreButtonDidClicked:);
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate scanOperationBar:self
                   moreButtonDidClicked:button];
    }
}

#pragma mark - setter & getter

- (void)setFrame:(CGRect)frame {
    frame.size.height = kScanOperationBarHeight;
    [super setFrame:frame];
}

- (UIButton *)photoButton {
    if (nil == _photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setImage:[UIImage imageNamed:@"scan_operation_photo"]
                      forState:UIControlStateNormal];
        [_photoButton setImage:[UIImage imageNamed:@"scan_operation_photo_highlighted"]
                      forState:UIControlStateHighlighted];
        [_photoButton addTarget:self
                         action:@selector(photoButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoButton;
}

- (UIButton *)flashButton {
    if (nil == _flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashButton setImage:[UIImage imageNamed:@"scan_operation_flash_on"]
                      forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"scan_operation_flash_on_highlighted"]
                      forState:UIControlStateHighlighted];
        [_flashButton setImage:[UIImage imageNamed:@"scan_operation_flash_off"]
                      forState:UIControlStateSelected];
        [_flashButton addTarget:self
                         action:@selector(flashButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashButton;
}

- (UIButton *)moreButton {
    if (nil == _moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"scan_operation_more"]
                     forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"scan_operation_more_highlighted"]
                     forState:UIControlStateHighlighted];
        [_moreButton addTarget:self
                        action:@selector(moreButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

@end
