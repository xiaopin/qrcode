//
//  PCScanResultOperation.h
//  ScanQRCode
//
//  Created by xiaopin on 16/5/14.
//
//

#import <Foundation/Foundation.h>

/**
 *  操作回调
 *
 *  @param scanResultString 扫码结果字符串
 */
typedef void(^ScanResultOperationCallback)(NSString * _Nullable scanResultString);


@interface PCScanResultOperation : NSObject

@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *icon;
@property (nonatomic, copy, nullable) ScanResultOperationCallback callback;

+ (_Nullable instancetype)operationWithName:(NSString * _Nullable)name
                                       icon:(NSString * _Nullable)icon
                              callbackBlock:(ScanResultOperationCallback _Nullable)callback;

@end
