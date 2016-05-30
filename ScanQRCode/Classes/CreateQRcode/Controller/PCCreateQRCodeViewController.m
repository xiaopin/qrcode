//
//  PCCreateQRCodeViewController.m
//  ScanQRCode
//
//  Created by nhope on 16/5/30.
//
//

#import "PCCreateQRCodeViewController.h"
#import "PCQRcodeResultView.h"
#import <MessageUI/MessageUI.h>

@interface PCCreateQRCodeViewController ()<PCQRcodeResultViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PCCreateQRCodeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生成二维码";
    self.view.backgroundColor = kGlobalBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)createQRCodeButtonAction:(UIButton *)sender {
    NSString *codeString = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nil == codeString || [codeString isEqualToString:@""]) {
        alertMessage(nil, @"请先输入文本内容", nil);
        return;
    }
    
    [_textView endEditing:YES];
    [_textView setText:@""];
    
    NSData *codeData = [codeString dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:codeData forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    CIImage *qrCIImage = [filter outputImage];
    
    UIImage *qrImage = [self createNonInterpolatedUIImageFormCIImage:qrCIImage withSize:300.0];
    // 自定义二维码颜色
//    qrImage = [self imageBlackToTransparent:qrImage withRed:80 andGreen:180 andBlue:80];

    PCQRcodeResultView *qrcodeView = [[PCQRcodeResultView alloc] init];
    [qrcodeView setFrame:self.view.bounds];
    [qrcodeView setQRcodeImage:qrImage];
    qrcodeView.delegate = self;
    [self.view addSubview:qrcodeView];
    
}


- (void)writeToSavedPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        alertMessage(@"图片保存失败", @"请检查是否关闭了相册访问权限", nil);
    }
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - PCQRcodeResultViewDelegate

- (void)qrcodeResultView:(PCQRcodeResultView *)view didLongPressQRcodeImage:(UIImage *)image {
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(image) weakImage = image;
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存到本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(weakImage, weakSelf, @selector(writeToSavedPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }];
    UIAlertAction *sendEmail = [UIAlertAction actionWithTitle:@"发送邮件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![MFMailComposeViewController canSendMail]) {
            alertMessage(nil, @"请先设置邮件账户", nil);
            return;
        }
        NSData *imageData = UIImagePNGRepresentation(weakImage);
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        [vc setSubject:@"#二维码分享#"];
        [vc setMessageBody:@"二维码分享" isHTML:NO];
        [vc addAttachmentData:imageData mimeType:@"image/png" fileName:@"qrcode.png"];
        [vc setMailComposeDelegate:weakSelf];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    alertMessageSheet(nil, nil, @[save, sendEmail, cancel]);
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (error) {
        alertMessage(@"邮件发送失败", [error.userInfo objectForKey:NSLocalizedDescriptionKey], nil);
    }
}

#pragma mark - Private

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

@end
