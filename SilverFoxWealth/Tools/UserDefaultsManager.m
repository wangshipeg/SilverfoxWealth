//
//  UserDefaultsManager.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UserDefaultsManager.h"
#import "IndividualInfoManage.h"
#import "CommunalInfo.h"
#import <SSKeychain.h>
#import "DateHelper.h"
#import "CacheHelper.h"



extern NSString *BankName;
extern NSString *BankCode;
extern NSString *BankNum;
extern NSString *Quota;

@implementation UserDefaultsManager

#pragma -mark 手势密码

//根据用户信息判断 是否存在手势密码
+ (NSString *)gesturePasswordIsExistWith:(NSString *)userId {

//    KeychainItemWrapper *keychin=[[KeychainItemWrapper alloc] initWithIdentifier:UserGesturePassword accessGroup:nil];
//    NSString *password=[keychin objectForKey:(__bridge id)kSecValueData];
//    if (![password isEqualToString:@""]) {
//        isExit=YES; //如果不存在 返回NO
//    }
//    return isExit;
    
    NSString *resultStr= [SSKeychain passwordForService:UserGesturePasswordService account:userId];
    if (!resultStr) {
        return nil;
    }
    return resultStr;
}
// 清空手势密码
+ (void)clearUserGesturePasswordWith:(NSString *)userId {
    [SSKeychain deletePasswordForService:UserGesturePasswordService account:userId];
    
}
// 保存手势密码
+ (void)saveUserGesturePassword:(NSString *)passwordStr userId:(NSString *)userId {
    [SSKeychain setPassword:passwordStr forService:UserGesturePasswordService account:userId];
}

#pragma -mark 用户请求时使用的api key
//查询用户本地缓存的api key
+ (NSString *)searchUserApiKey {
    NSUserDefaults *defult=[NSUserDefaults  standardUserDefaults];
    if (![defult objectForKey:UserRequestApiKey]) {
        return nil;
    }
    NSString *keyStr=[defult objectForKey:UserRequestApiKey];
    return keyStr;
}

//保存用户 api key  如果已经有缓存 先清理掉
+ (void)saveUserApiKey:(NSString *)key  {
    NSUserDefaults *defult=[NSUserDefaults  standardUserDefaults];
    NSString *resultStr=[NSString stringWithFormat:@"%@",key];
    [defult setObject:resultStr forKey:UserRequestApiKey];
}

//清除用户本地缓存的api key
+ (void)clearUserApiKey {
    NSUserDefaults *defult=[NSUserDefaults  standardUserDefaults];
    if ([defult objectForKey:UserRequestApiKey]) {
        [defult removeObjectForKey:UserRequestApiKey];
    }
}
#pragma -mark 用户授权 过期时间
+ (NSString *)searchAuthExpiresIn
{
    NSUserDefaults *defult=[NSUserDefaults  standardUserDefaults];
    if (![defult objectForKey:UserExpriresIn]) {
        return nil;
    }
    NSString *keyStr=[defult objectForKey:UserExpriresIn];
    return keyStr;
}
+ (void)saveUserAuthExpriresIn:(NSString *)exprires
{
    NSUserDefaults *defult=[NSUserDefaults  standardUserDefaults];
    NSString *resultStr=[NSString stringWithFormat:@"%@",exprires];
    [defult setObject:resultStr forKey:UserExpriresIn];
}
+ (void)clearUserExpriresIn
{
    NSUserDefaults *defult=[NSUserDefaults  standardUserDefaults];
    if ([defult objectForKey:UserExpriresIn]) {
        [defult removeObjectForKey:UserExpriresIn];
    }
}

#pragma -mark 用户授权的refresh_token
+ (NSString *)searchUserRefreshToken
{
    NSUserDefaults *defult=[NSUserDefaults  standardUserDefaults];
    if (![defult objectForKey:UserRefreshToken]) {
        return nil;
    }
    NSString *keyStr=[defult objectForKey:UserRefreshToken];
    return keyStr;

}

+ (void)saveUserRefreshToken:(NSString *)refreshToken
{
    NSUserDefaults *defult=[NSUserDefaults  standardUserDefaults];
    NSString *resultStr=[NSString stringWithFormat:@"%@",refreshToken];
    [defult setObject:resultStr forKey:UserRefreshToken];
}

+ (void)clearUserRefreshToken
{
    NSUserDefaults *defult=[NSUserDefaults  standardUserDefaults];
    if ([defult objectForKey:UserRefreshToken]) {
        [defult removeObjectForKey:UserRefreshToken];
    }
}


















@end
