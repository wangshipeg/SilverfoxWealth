//
//  RegisterPageVC.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

//本页面可能用来注册 也可能用来找回登录密码 所以分开
typedef NS_ENUM(NSInteger, RegisterWorkStatus) {
//    RegisterState       = 1,//注册
    RetrievePasswordState   = 2,//找回密码
};

@interface RegisterPageVC : UIViewController<UITextFieldDelegate>
@property (nonatomic, copy) NSString *cellPhoneStr;
@property (nonatomic, assign) RegisterWorkStatus workStatus;


@end
