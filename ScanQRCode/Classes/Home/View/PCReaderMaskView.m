//
//  PCReaderMaskView.m
//  ScanQRCode
//
//  Created by xiaopin on 16/5/13.
//
//

#import "PCReaderMaskView.h"

@interface PCReaderMaskView ()

@property (nonatomic, strong, nullable) UIView *scanBoxView;
@property (nonatomic, strong, nullable) UIImageView *topLeftImageView;
@property (nonatomic, strong, nullable) UIImageView *topRightImageView;
@property (nonatomic, strong, nullable) UIImageView *bottomLeftImageView;
@property (nonatomic, strong, nullable) UIImageView *bottomRightImageView;
@property (nonatomic, strong, nullable) UIImageView *scanLineImageView;

@end


@implementation PCReaderMaskView
{
    NSTimer *_animateTimer;
}

/**
 *  边框图片的宽高
 */
static CGFloat const kReaderMaskViewImageViewWidthAndHeight = 16.0;
/**
 *  边框宽度
 */
static CGFloat const kReaderMaskViewBorderWidth = 0.5;

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scanBoxView];
        [self.scanBoxView addSubview:self.topLeftImageView];
        [self.scanBoxView addSubview:self.topRightImageView];
        [self.scanBoxView addSubview:self.bottomLeftImageView];
        [self.scanBoxView addSubview:self.bottomRightImageView];
        [self.scanBoxView addSubview:self.scanLineImageView];
    }
    return self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.scanBoxView.frame);
    CGFloat height = CGRectGetHeight(self.scanBoxView.frame);
    CGFloat centerMargin = kReaderMaskViewImageViewWidthAndHeight / 2;
    _scanBoxView.frame = self.scanRect;
    _topLeftImageView.center = CGPointMake(centerMargin + kReaderMaskViewBorderWidth, centerMargin + kReaderMaskViewBorderWidth);
    _topRightImageView.center = CGPointMake(width - centerMargin - kReaderMaskViewBorderWidth, centerMargin + kReaderMaskViewBorderWidth);
    _bottomLeftImageView.center = CGPointMake(centerMargin + kReaderMaskViewBorderWidth, height - centerMargin - kReaderMaskViewBorderWidth);
    _bottomRightImageView.center = CGPointMake(width - centerMargin - kReaderMaskViewBorderWidth, height - centerMargin - kReaderMaskViewBorderWidth);
    _scanLineImageView.frame = CGRectMake(0.0, 0.0, width, 12.0);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[[UIColor blackColor] colorWithAlphaComponent:0.5] setFill];
    
    CGMutablePathRef screenPath = CGPathCreateMutable();
    CGPathAddRect(screenPath, NULL, self.bounds);
    
    CGMutablePathRef scanPath = CGPathCreateMutable();
    CGPathAddRect(scanPath, NULL, self.scanRect);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddPath(path, NULL, screenPath);
    CGPathAddPath(path, NULL, scanPath);
    
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathEOFill);
    
    CGPathRelease(screenPath);
    CGPathRelease(scanPath);
    CGPathRelease(path);
}

#pragma mark - Public

- (void)startScanLineAnimate {
    [self stopScanLineAnimate];
    _animateTimer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(animateTimerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_animateTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopScanLineAnimate {
    if (_animateTimer) {
        [_animateTimer invalidate];
        _animateTimer = nil;
    }
}

- (void)animateTimerAction:(NSTimer *)sender {
    CGRect frame = _scanLineImageView.frame;
    if (CGRectGetMaxY(frame) >= CGRectGetHeight(_scanRect)) {
        frame.origin.y = 0.0;
    } else {
        frame.origin.y += 1.0;
    }
    _scanLineImageView.frame = frame;
}

#pragma mark - setter & getter

- (UIView *)scanBoxView {
    if (nil == _scanBoxView) {
        _scanBoxView = [[UIView alloc] init];
        _scanBoxView.layer.borderWidth = kReaderMaskViewBorderWidth;
        _scanBoxView.layer.borderColor = [UIColor whiteColor].CGColor;
        _scanBoxView.backgroundColor = [UIColor clearColor];
    }
    return _scanBoxView;
}

- (UIImageView *)topLeftImageView {
    
    if (nil == _topLeftImageView) {
        UIImage *image = [UIImage imageNamed:@"QRCodeTopLeft"];
        _topLeftImageView = [[UIImageView alloc] initWithImage:image];
        _topLeftImageView.bounds = (CGRect){CGPointZero, CGSizeMake(kReaderMaskViewImageViewWidthAndHeight, kReaderMaskViewImageViewWidthAndHeight)};
    }
    return _topLeftImageView;
}


- (UIImageView *)topRightImageView {
    
    if (nil == _topRightImageView) {
        UIImage *image = [UIImage imageNamed:@"QRCodeTopRight"];
        _topRightImageView = [[UIImageView alloc] initWithImage:image];
        _topRightImageView.bounds = (CGRect){CGPointZero, CGSizeMake(kReaderMaskViewImageViewWidthAndHeight, kReaderMaskViewImageViewWidthAndHeight)};
    }
    return _topRightImageView;
}


- (UIImageView *)bottomLeftImageView {
    
    if (nil == _bottomLeftImageView) {
        UIImage *image = [UIImage imageNamed:@"QRCodeBottomLeft"];
        _bottomLeftImageView = [[UIImageView alloc] initWithImage:image];
        _bottomLeftImageView.bounds = (CGRect){CGPointZero, CGSizeMake(kReaderMaskViewImageViewWidthAndHeight, kReaderMaskViewImageViewWidthAndHeight)};
    }
    return _bottomLeftImageView;
}


- (UIImageView *)bottomRightImageView {
    
    if (nil == _bottomRightImageView) {
        UIImage *image = [UIImage imageNamed:@"QRCodeBottomRight"];
        _bottomRightImageView = [[UIImageView alloc] initWithImage:image];
        _bottomRightImageView.bounds = (CGRect){CGPointZero, CGSizeMake(kReaderMaskViewImageViewWidthAndHeight, kReaderMaskViewImageViewWidthAndHeight)};
    }
    return _bottomRightImageView;
}

- (UIImageView *)scanLineImageView {
    if (nil == _scanLineImageView) {
        UIImage *image = [UIImage imageNamed:@"QRCodeLine"];
        _scanLineImageView = [[UIImageView alloc] initWithImage:image];
    }
    return _scanLineImageView;
}

@end
