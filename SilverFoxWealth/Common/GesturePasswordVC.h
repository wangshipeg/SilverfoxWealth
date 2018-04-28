//
//  GesturePasswordVC.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"

typedef void (^closeGesturePasswordBlock)(); //关闭手势密码时使用

@interface GesturePasswordVC : UIViewController<VerificationDelegate,ResetDelegate>
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) NSString *viewPersentStr;

@property (nonatomic, copy) closeGesturePasswordBlock closeBlock;
//关闭手势密码时使用
- (void)passCloseEventWith:(closeGesturePasswordBlock)closeGesturePasswordBlock;

//忘记手势密码时 走完登陆流程 成功后调用
- (void)retrieveGesturePasswordFinish;

@end
