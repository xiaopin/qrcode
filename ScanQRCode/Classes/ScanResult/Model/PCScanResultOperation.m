//
//  PCScanResultOperation.m
//  ScanQRCode
//
//  Created by xiaopin on 16/5/14.
//
//

#import "PCScanResultOperation.h"

@implementation PCScanResultOperation

+ (instancetype)operationWithName:(NSString *)name
                             icon:(NSString *)icon
                    callbackBlock:(ScanResultOperationCallback)callback {
    
    PCScanResultOperation *operation = [[PCScanResultOperation alloc] init];
    operation.name = name;
    operation.icon = icon;
    operation.callback = callback;
    return operation;
}

@end
