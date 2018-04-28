//
//  UserInfoUpdate.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD.h>

@interface UserInfoUpdate : NSObject

/**
 *更新用户信息
 */
+ (void)updateUserInfoWithTargerVC:(UIViewController *)targerVC;


/**
 *清除用户本地消息
 */
+ (void)clearUserLocalInfo;


@end
