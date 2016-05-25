//
//  NSString+PC.h
//  ScanQRCode
//
//  Created by xiaopin on 16/5/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (PC)

/**
 *  对指定的字符串进行MD5加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 返回经过MD5加密的字符串
 */
+ (NSString *)MD5WithString:(NSString *)string;

/**
 *  获取字符串本身的MD5加密字符串
 *
 *  @return 返回经过MD5加密的字符串
 */
- (NSString *)MD5;

/**
 *  判断字符串是否为空(nil|@""|空白字符)
 *
 *  @return YES:空字符串 NO:非空字符串
 */
+ (BOOL)isEmpty:(NSString *)string;

/**
 *  判断字符串是否为空，并且将"0"视为空(nil|@""|空白字符|@"0")
 *
 *  @return YES:空字符串 NO:非空字符串
 */
+ (BOOL)isEmptyIgnoreZero:(NSString *)string;

/**
 *  判断当前字符串是否为手机号码
 *
 *  @return YES:是手机号码 NO:不是手机号码
 */
+ (BOOL)isMobileNumberWithString:(NSString *)string;

/**
 *  对字符串进行URLencode编码
 *
 *  @param string 需要编码的字符串
 *
 *  @return 返回经过URLencode编码后的字符串
 */
+(NSString *)URLencodeWithString:(NSString *)string;

/**
 *  去除字符串首尾空格字符串
 *
 *  @param string 需要格式化的字符串
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)trimWithString:(NSString *)string;

/**
 *  用*隐藏手机号码
 *
 *  @param mobile 11位数手机号码
 *
 *  @return 格式化后的手机号码(如:188****8888)
 */
+ (NSString *)formatMobile:(NSString *)mobile;

/**
 *  判断给定的字符串是否为Email地址
 *
 *  @param email 邮箱地址
 *
 *  @return YES:合法的邮箱地址
 */
+ (BOOL)isEmail:(NSString *)email;

/**
 *  判断给定的字符串是否为合法URL链接
 *
 *  @param url 待检验的URL字符串
 *
 *  @return
 */
+ (BOOL)isURLString:(NSString *)url;

@end
