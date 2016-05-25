//
//  PCScanResultViewController.m
//  ScanQRCode
//
//  Created by xiaopin on 16/5/14.
//
//

#import "PCScanResultViewController.h"
#import "PCScanResultOperation.h"
#import "NSString+PC.h"
#import <MessageUI/MessageUI.h>

@interface PCScanResultViewController ()
<MFMessageComposeViewControllerDelegate,
MFMailComposeViewControllerDelegate>

@property (nonatomic, strong, nullable) NSArray<PCScanResultOperation *> *operations;

@end

@implementation PCScanResultViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码结果";
    [self.view setBackgroundColor:kGlobalBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.operations.count;
    }
    return 0;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * const reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.accessoryType = indexPath.section == 0 ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        cell.textLabel.text = self.scanResultString;
    } else if (indexPath.section == 1) {
        PCScanResultOperation *operation = [_operations objectAtIndex:indexPath.row];
        cell.textLabel.text = operation.name;
        cell.imageView.image = [UIImage imageNamed:operation.icon];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        PCScanResultOperation *operation = [_operations objectAtIndex:indexPath.row];
        if (nil != operation.callback) {
            operation.callback(self.scanResultString);
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSString *result = self.scanResultString;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:result];
            alertMessage(nil, @"已复制到剪贴板", nil);
        }];
        [alertController addAction:copyAction];
        
        if ([NSString isURLString:result]) {
            UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Safari打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *URL = [NSURL URLWithString:result];
                UIApplication *application = [UIApplication sharedApplication];
                if (URL && [application canOpenURL:URL]) {
                    [application openURL:URL];
                }
            }];
            [alertController addAction:openAction];
        }
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - <MFMessageComposeViewControllerDelegate>

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <MFMailComposeViewControllerDelegate>

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter & getter

- (NSArray<PCScanResultOperation *> *)operations {
    if (nil == _operations) {
        __weak __typeof(self) weakSelf = self;
        PCScanResultOperation *searchOperation = [PCScanResultOperation operationWithName:@"百度搜索" icon:@"scan_result_search" callbackBlock:^(NSString * _Nullable scanResultString) {
            NSString *urlString = [NSString stringWithFormat:@"https://www.baidu.com/s?word=%@", [NSString URLencodeWithString:scanResultString]];
            NSURL *URL = [NSURL URLWithString:urlString];
            UIApplication *application = [UIApplication sharedApplication];
            if (URL && [application canOpenURL:URL]) {
                [application openURL:URL];
            } else {
                alertMessage(nil, @"Safari无法打开该链接，请检查链接有效性", nil);
            }
        }];
        
        PCScanResultOperation *smsOperation = [PCScanResultOperation operationWithName:@"通过短信发送" icon:@"scan_result_sms" callbackBlock:^(NSString * _Nullable scanResultString) {
            MFMessageComposeViewController *smsVc = [[MFMessageComposeViewController alloc] init];
            smsVc.body = scanResultString;
            smsVc.messageComposeDelegate = weakSelf;
            [weakSelf presentViewController:smsVc animated:YES completion:nil];
        }];
        
        PCScanResultOperation *emailOperation = [PCScanResultOperation operationWithName:@"通过邮件发送" icon:@"scan_result_mail" callbackBlock:^(NSString * _Nullable scanResultString) {
            if (![MFMailComposeViewController canSendMail]) {
                alertMessage(nil, @"用户没有设置邮件账户", nil);
                return;
            }
            MFMailComposeViewController *mailVc = [[MFMailComposeViewController alloc] init];
            [mailVc setSubject:@"#扫码分享#"];
            [mailVc setMessageBody:scanResultString isHTML:NO];
            mailVc.mailComposeDelegate = weakSelf;
            [weakSelf presentViewController:mailVc animated:YES completion:nil];
        }];
        _operations = @[searchOperation, smsOperation, emailOperation];
    }
    return _operations;
}

@end
