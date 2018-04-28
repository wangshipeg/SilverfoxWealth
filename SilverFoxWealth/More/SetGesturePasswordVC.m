//
//  SetGesturePasswordVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SetGesturePasswordVC.h"
#import "GesturePasswordVC.h"
#import "UILabel+LabelStyle.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"

@interface SetGesturePasswordVC ()

@end

@implementation SetGesturePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
}

- (void)UIDecorate {
    self.view.backgroundColor=[UIColor whiteColor];
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"设置手势密码";
    self.title = @"设置手势密码";
    [self.view addSubview:customNav];
    
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    UIImageView *imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SetGesture.png"]];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(114);
        make.width.equalTo(@103);
        make.height.equalTo(@209);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel *titleLB=[[UILabel alloc] init];
    [self.view addSubview:titleLB];
    titleLB.text=@"设置手势密码之后，他人借用您的手机将无法打开银狐财富";
    titleLB.numberOfLines=0;
    titleLB.textAlignment=NSTextAlignmentCenter;
    [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@273);
        make.top.equalTo(imageV.mas_bottom).offset(30);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    RoundCornerClickBT *setPasswordBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:setPasswordBT];
    [setPasswordBT setTitle:@"设置手势密码" forState:UIControlStateNormal];
    setPasswordBT.titleLabel.font=[UIFont systemFontOfSize:16];
    setPasswordBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
    [FastAnimationAdd codeBindAnimation:setPasswordBT];
    [setPasswordBT addTarget:self action:@selector(enterSetGesturePasswordPage:) forControlEvents:UIControlEventTouchUpInside];
    [setPasswordBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLB.mas_bottom).offset(30);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    
}

- (void)enterSetGesturePasswordPage:(UIButton *)sender {
    GesturePasswordVC *gestureVC = [[GesturePasswordVC alloc] init];
    [self presentViewController:gestureVC animated:YES completion:nil];
}






































@end

