//
//  PCHomeViewController.m
//  ScanQRCode
//
//  Created by xiaopin on 16/5/13.
//
//

#import "PCHomeViewController.h"
#import "PCReaderMaskView.h"
#import <AVFoundation/AVFoundation.h>
#import "PCScanResultViewController.h"
#import "PCScanOperationBar.h"

@interface PCHomeViewController ()
<AVCaptureMetadataOutputObjectsDelegate,
PCScanOperationBarDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic, nullable, strong) AVCaptureSession *captureSession;
@property (nonatomic, nullable, weak) PCReaderMaskView *scanMaskView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@end

@implementation PCHomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kGlobalBackgroundColor];
    [self requestAuthorizationAccessForCamera];
    self.noticeLabel.text = @"将取景框对准二维码/条形码\n即可自动扫描";
    // 添加底部操作条
    PCScanOperationBar *operationBar = [[PCScanOperationBar alloc] init];
    operationBar.frame = CGRectMake(0.0, CGRectGetHeight(self.view.frame) - kScanOperationBarHeight, CGRectGetWidth(self.view.frame), kScanOperationBarHeight);
    operationBar.delegate = self;
    [self.view addSubview:operationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_captureSession) {
        [_captureSession startRunning];
    }
    [_scanMaskView startScanLineAnimate];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_captureSession) {
        [_captureSession stopRunning];
    }
    [_scanMaskView stopScanLineAnimate];
}

#pragma mark - Private

/**
 *  请求摄像头访问权限
 */
- (void)requestAuthorizationAccessForCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            [self initCaptureSession];
            break;
        case AVAuthorizationStatusNotDetermined: {
            __weak __typeof(self) weakSelf = self;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [weakSelf initCaptureSession];
                } else {
                    alertMessage(nil, @"没有开启摄像头访问权限", nil);
                }
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            alertMessage(nil, @"没有开启摄像头访问权限", nil);
            break;
        default:
            break;
    }
}

- (void)initCaptureSession {
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (nil != error) {
        alertMessage(nil, @"该设备没有摄像头", nil);
        return;
    }
    
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:output];
    // 设置扫描类型
    NSArray *objectTypes = @[
                             AVMetadataObjectTypeQRCode
                             ];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [output setMetadataObjectTypes:objectTypes];
    
    // 设置输出对象
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [previewLayer setFrame:self.view.bounds];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    // 扫描区域
    CGRect scanRect = CGRectMake( (CGRectGetWidth(self.view.frame)-kScanBoxWidth) / 2,
                                 CGRectGetMaxY(self.noticeLabel.frame) + 20.0,
                                 kScanBoxWidth,
                                 kScanBoxHeight);
    output.rectOfInterest = [previewLayer metadataOutputRectOfInterestForRect:scanRect];
    // 添加扫描边框
    PCReaderMaskView *maskView = [[PCReaderMaskView alloc] initWithFrame:self.view.bounds];
    maskView.scanRect = scanRect;
    [self.view insertSubview:maskView belowSubview:self.noticeLabel];
    [maskView startScanLineAnimate];
    _scanMaskView = maskView;
    
    [_captureSession startRunning];
}

#pragma mark - <AVCaptureMetadataOutputObjectsDelegate>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *codeObject = [metadataObjects lastObject];
        if ([codeObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            PCScanResultViewController *resultController = [[PCScanResultViewController alloc] initWithStyle:UITableViewStyleGrouped];
            resultController.scanResultString = codeObject.stringValue;
            [self.navigationController pushViewController:resultController animated:YES];
        }
        [_captureSession stopRunning];
    }
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{
                                                        CIDetectorAccuracy:CIDetectorAccuracyHigh
                                                        }];
    CIImage *image = [[CIImage alloc] initWithImage:originalImage];
    NSArray *features = [detector featuresInImage:image options:nil];
    CIQRCodeFeature *feature = [features lastObject];
    if (feature) {
        PCScanResultViewController *resultController = [[PCScanResultViewController alloc] initWithStyle:UITableViewStyleGrouped];
        resultController.scanResultString = feature.messageString;
        [self.navigationController pushViewController:resultController animated:YES];
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
        alertMessage(nil, @"该图片不存在二维码", nil);
    }
}

#pragma mark - <PCScanOperationBarDelegate>

- (void)scanOperationBar:(PCScanOperationBar *)operationBar photoButtonDidClicked:(UIButton *)button {
    BOOL isAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if (!isAvailable) {
        alertMessage(nil, @"访问相册失败", nil);
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)scanOperationBar:(PCScanOperationBar *)operationBar flashButtonDidClicked:(UIButton *)button {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device isTorchAvailable]) {
        [device lockForConfiguration:nil];
        if ([device torchMode] == AVCaptureTorchModeOn) {
            [device setTorchMode:AVCaptureTorchModeOff];
        } else {
            [device setTorchMode:AVCaptureTorchModeOn];
        }
        [device unlockForConfiguration];
    }
}

- (void)scanOperationBar:(PCScanOperationBar *)operationBar moreButtonDidClicked:(UIButton *)button {
    // TODO:更多操作
    alertMessage(nil, @"暂无更多操作", nil);
}

@end
