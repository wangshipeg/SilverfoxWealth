//
//  Validation.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/3/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

//本类用来验证 用户输入的 各种号码的格式

#import <Foundation/Foundation.h>

@interface Validation : NSObject


//验证email格式
+(BOOL)email:(NSString *)str;

//验证手机号
+(BOOL)mobileNum:(NSString *)str;

//验证身份证号
+(BOOL)validateIdentityCard: (NSString *)identityCard;

//验证密码字母和数字 6-20位
+ (BOOL)pwd:(NSString *)str;

//一个字符 是否是字母或者数字
+ (BOOL)oneLengthpwd:(NSString *)str;


//银行卡号校验
+(BOOL)bankCardNum:(NSString *)str;


@end
