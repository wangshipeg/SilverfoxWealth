//
//  RequestOAth.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RequestOAth : NSObject


/**
 *授权请求
 */
+ (void)authenticationWithclient_id:(NSString *)client_id response_type:(NSString *)response_type callback:(void(^)(BOOL succeedState))callback;
/**
 *刷新授权
 */
+ (void)authenticationUpdateWithclient_id:(NSString *)client_id response_type:(NSString *)response_type callback:(void(^)(BOOL succeedState))callback;

@end
