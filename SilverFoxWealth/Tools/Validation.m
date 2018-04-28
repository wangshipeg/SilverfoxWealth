//
//  Validation.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/3/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Validation.h"
#import <UIKit/UIKit.h>


@implementation Validation


//验证email格式
+(BOOL)email:(NSString *)str {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}

//验证手机号
+(BOOL)mobileNum:(NSString *)str {
    NSString *regex = @"(1[0-9])\\d{9}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}

//验证身份证号
+(BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length != 18) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//验证密码 
+ (BOOL)pwd:(NSString *)str {
    NSString *regex = @"[A-Z0-9a-z]{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}
//一个字符 是否是字母或者数字
+ (BOOL)oneLengthpwd:(NSString *)str {
    NSString *regex = @"[A-Z0-9a-z]{1}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}

//银行卡号校验
+(BOOL)bankCardNum:(NSString *)str {
    BOOL flag;
    if (str.length==0) {
        flag=NO;
        return flag;
    }
    
    NSString *regex=@"^(\\d{15,30})";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicate evaluateWithObject:str];
}
















































@end
