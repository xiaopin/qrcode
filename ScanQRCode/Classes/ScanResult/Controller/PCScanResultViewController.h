//
//  PCScanResultViewController.h
//  ScanQRCode
//
//  Created by xiaopin on 16/5/14.
//
//

#import <UIKit/UIKit.h>

@interface PCScanResultViewController : UITableViewController

/**
 *  扫描结果字符串
 */
@property (nonatomic, copy, nullable) NSString *scanResultString;

@end
