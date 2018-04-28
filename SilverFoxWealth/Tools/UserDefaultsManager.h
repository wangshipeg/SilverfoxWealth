//
//  UserDefaultsManager.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndividualInfoManage.h"
#import "UserInfoUpdate.h"


@interface UserDefaultsManager : NSObject



///////手势密码相关

/**
 *根据用户id判断 是否存在手势密码
 */
+ (NSString *)gesturePasswordIsExistWith:(NSString *)userId;
/**
 *清空手势密码
 */
+ (void)clearUserGesturePasswordWith:(NSString *)userId;


+ (void)saveUserGesturePassword:(NSString *)passwordStr userId:(NSString *)userId ;



//////////// 用户 授权 相关

/**
 *查询用户本地缓存的api key
 */
+ (NSString *)searchUserApiKey;

/**
 *保存用户 api key  如果已经有缓存 先清理掉
 */
+ (void)saveUserApiKey:(NSString *)key;

/**
 *清除用户本地缓存的api key
 */
+ (void)clearUserApiKey;

/**
 查询, 保存, 清除授权过期时间
 */
+ (NSString *)searchAuthExpiresIn;
+ (void)saveUserAuthExpriresIn:(NSString *)exprires;
+ (void)clearUserExpriresIn;
/**
 *查询, 保存 ,清除刷新的refresh_token
 */
+ (NSString *)searchUserRefreshToken;
+ (void)saveUserRefreshToken:(NSString *)refreshToken;
+ (void)clearUserRefreshToken;

@end







