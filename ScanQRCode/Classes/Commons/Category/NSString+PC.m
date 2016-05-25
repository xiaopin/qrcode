//
//  NSString+PC.m
//  ACSClient
//
//  Created by Artpower on 15/8/24.
//  Copyright (c) 2015年 深圳艺力文化发展有限公司. All rights reserved.
//

#import "NSString+PC.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (PC)

+ (NSString *)MD5WithString:(NSString *)string {
    return [string MD5];
}

- (NSString *)MD5 {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    const char *CString = [self UTF8String];
    CC_MD5(CString, (CC_LONG)strlen(CString), result);
    NSMutableString *md5String = [NSMutableString stringWithCapacity: (CC_MD5_DIGEST_LENGTH * 2)];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x",result[i]];
    }
    
    return md5String;
}

+ (BOOL)isEmpty:(NSString *)string {
    if (string == nil || [string isEqualToString:@""]) {
        return YES;
    }
    NSString *regexp = @"^\\s+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ MATCHES %@", string, regexp];
    return [predicate evaluateWithObject:string];
}

+ (BOOL)isEmptyIgnoreZero:(NSString *)string {
    return [NSString isEmpty:string] || [string isEqualToString:@"0"];
}

+ (BOOL)isMobileNumberWithString:(NSString *)string {
    NSString *mobile = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([NSString isEmpty:mobile]) {
        return NO;
    }
    NSString *regexp = @"^1(3|4|5|8)\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ MATCHES %@", mobile, regexp];
    
    return [predicate evaluateWithObject:mobile];
}

+(NSString *)URLencodeWithString:(NSString *)string {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                             (CFStringRef)string,
                                                                                             NULL,
                                                                                             (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                             kCFStringEncodingUTF8));
    return result;
}

+ (NSString *)trimWithString:(NSString *)string {
    NSString *result = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return result;
}

+ (NSString *)formatMobile:(NSString *)mobile {
    mobile = [mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![NSString isMobileNumberWithString:mobile]) {
        return @"";
    }
    return [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

+ (BOOL)isEmail:(NSString *)email {
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *regexp = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp];
    return [predicate evaluateWithObject:email];
}

+ (BOOL)isURLString:(NSString *)url {
    NSString *regexp = @"^http[s]?://(\\w+(-\\w+)*)(\\.(\\w+(-\\w+)*))*(\\?\\S*)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp];
    return [predicate evaluateWithObject:url];
}

@end
