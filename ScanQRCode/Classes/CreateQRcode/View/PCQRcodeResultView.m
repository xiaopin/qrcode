//
//  PCQRcodeResultView.m
//  ScanQRCode
//
//  Created by nhope on 16/5/30.
//
//

#import "PCQRcodeResultView.h"

@interface PCQRcodeResultView ()

@property (nonatomic, strong, nullable) UIImageView *qrImageView;
@property (nonatomic, strong, nullable) UIButton *closeButton;

@end


@implementation PCQRcodeResultView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self addSubview:self.qrImageView];
        [self addSubview:self.closeButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat padding = 10.0;
    CGFloat width = MIN(_qrImageView.image.size.width, CGRectGetWidth(self.frame) - padding * 2);
    CGFloat height = MIN(_qrImageView.image.size.height, CGRectGetHeight(self.frame) - padding * 2);
    _qrImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - width) / 2,
                                    (CGRectGetHeight(self.frame) - height) / 2,
                                    width,
                                    height);
    _closeButton.center = CGPointMake(CGRectGetMinX(_qrImageView.frame),
                                      CGRectGetMinY(_qrImageView.frame));
}

#pragma mark - Action

- (void)longPressGestureRecognizerAction:(UILongPressGestureRecognizer *)sender {
    BOOL isResponds = [self.delegate respondsToSelector:@selector(qrcodeResultView:didLongPressQRcodeImage:)];
    if (isResponds) {
        UIImage *qrimage = _qrImageView.image;
        [self.delegate qrcodeResultView:self didLongPressQRcodeImage:qrimage];
    }
}

- (void)closeButtonAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - setter & getter

- (UIImageView *)qrImageView {
    if (nil == _qrImageView) {
        _qrImageView = [[UIImageView alloc] init];
        [_qrImageView setUserInteractionEnabled:YES];
        SEL action = @selector(longPressGestureRecognizerAction:);
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:action];
        [_qrImageView addGestureRecognizer:longGesture];
    }
    return _qrImageView;
}

- (UIButton *)closeButton {
    if (nil == _closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"X" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        [_closeButton setBackgroundColor:[UIColor lightGrayColor]];
        [_closeButton addTarget:self
                         action:@selector(closeButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _closeButton.bounds = CGRectMake(0.0, 0.0, 20.0, 20.0);
        [_closeButton.layer setCornerRadius:CGRectGetWidth(_closeButton.frame) / 2];
        [_closeButton.layer setMasksToBounds:YES];
    }
    return _closeButton;
}

- (void)setQRcodeImage:(UIImage *)qrimage {
    [_qrImageView setImage:qrimage];
}

@end
