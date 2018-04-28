//
//  GesturePasswordVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GesturePasswordVC.h"
#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "IndividualInfoVC.h"
#import "CommunalInfo.h"
#import "UserDefaultsManager.h"
#import "VCAppearManager.h"
#import "PromptLanguage.h"
#import "UILabel+LabelStyle.h"

@interface GesturePasswordVC ()
@property (nonatomic, strong) GesturePasswordView *gesturePasswordView;
@property (strong, nonatomic) UILabel *currentNameLB;
@property (strong, nonatomic) UILabel *currentPhoneLB;
@property (strong, nonatomic) UIButton *forgetBT;

@end

@implementation GesturePasswordVC
{
    NSString *previousString; //先前的密码
    NSString *password;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
    previousString=[NSString string];
    password=[UserDefaultsManager gesturePasswordIsExistWith:user.customerId];
    [self UIDecorate];
    //如果没设置手势密码 就进入设置流程
    if (!password) {
        //重置手势密码
        [self reset];
        self.forgetBT.hidden=YES;
    }else{//如果已经设置了手势密码就进行验证
        [self verify];
        if (user.name.length != 0) {
            NSString *nameStr=user.name;
            self.currentNameLB.text=[nameStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        }
        NSString *phoneStr=user.cellphone;
        self.currentPhoneLB.text=[phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.forgetBT.hidden=NO;
    }
}


#pragma -mark 验证手势密码
- (void)verify {
    _gesturePasswordView=[[GesturePasswordView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 80)];
    _gesturePasswordView.state.text=@"请验证手势密码";
    [_gesturePasswordView.tentacleView setVerificationDelegate:self];
    [_gesturePasswordView.tentacleView setStyle:1];
    [self.view addSubview:_gesturePasswordView];
    if (![_viewPersentStr isEqualToString:@"first"]) {
        [self.view addSubview:_customNav];
    }
}

#pragma -mark 重新设置手势密码
- (void)reset {
    _gesturePasswordView = [[GesturePasswordView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 80)];
    _gesturePasswordView.state.text = @"请设置手势密码";
    [_gesturePasswordView.tentacleView setResetDelegate:self];
    [_gesturePasswordView.tentacleView setStyle:2];
    [self.view addSubview:_gesturePasswordView];
    if (![_viewPersentStr isEqualToString:@"first"]) {
        [self.view addSubview:_customNav];
    }
}

- (void)forgetGesturePassword:(UIButton *)sender {
    AuthorizationAndLoginVC *phoneNumVC = [[AuthorizationAndLoginVC alloc] init];
    UINavigationController *entry = [[UINavigationController alloc] initWithRootViewController:phoneNumVC];
    [self presentViewController:entry animated:YES completion:nil];
}

#pragma -mark VerificationDelegate 验证手势密码 代理回调
-(BOOL)verification:(NSString *)result {
    
    if ([result isEqualToString:password]) {
        //输入正确 直接消失
        if (_closeBlock) { //如果是关闭手势密码 就用块回调回去
            _closeBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }
    
    [_gesturePasswordView.state setTextColor:[UIColor zheJiangBusinessRedColor]];
    [_gesturePasswordView.state setText:@"手势密码错误!"];
    return NO;
    
}

#pragma -mark ResetDelegate 设置手势密码 代理回调
-(BOOL)resetPassword:(NSString *)result {
    
    if ([previousString isEqualToString:@""]) {
        previousString = result;
        [_gesturePasswordView.state setTextColor:[UIColor zheJiangBusinessRedColor]];
        [_gesturePasswordView.tentacleView enterArgin];
        [_gesturePasswordView.state setText:@"请验证输入密码"];
        return YES;
    }else {
        //上一步设置密码后 这一步进行验证
        if ([result isEqualToString:previousString]) {
            //本地保存密码
            DLog(@"手势结果==%@",result);
            IndividualInfoManage *user=[IndividualInfoManage currentAccount];
            [UserDefaultsManager  saveUserGesturePassword:result userId:user.customerId];
            [self goBackPasswordManagePage];
            //设置成功 返回密码管理页 可以不用return
            return YES;
        }else {
            previousString =@"";
            [_gesturePasswordView.state setTextColor:[UIColor zheJiangBusinessRedColor]];
            _gesturePasswordView.state.numberOfLines = 2;
            [_gesturePasswordView.state setText:GesturePasswordForrTwiceDifferent];
            return NO;
        }
    }
}

- (void)passCloseEventWith:(closeGesturePasswordBlock)closeGesturePasswordBlock {
    _closeBlock=closeGesturePasswordBlock;
}

//返回密码管理页
- (void)goBackPasswordManagePage {
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

- (void)retrieveGesturePasswordFinish {
    //如果本地已存user说明 是从手势密码页进来的 先移除清理手势密码 再清除本地user {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (user) { //若存在用户
        [UserDefaultsManager clearUserGesturePasswordWith:user.customerId]; //删除这个手势密码
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}
- (void)UIDecorate {
    _customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        _customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        _customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    if (password) {
        _customNav.titleLabel.text = @"关闭手势密码";
    } else {
        _customNav.titleLabel.text = @"设置手势密码";
    }
    
    self.title = @"设置手势密码";
    if ([_viewPersentStr isEqualToString:@"first"]) {
        [self.view addSubview:_customNav];
    }
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    UIImageView *backImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gesture.png"]];
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    if (![_viewPersentStr isEqualToString:@"first"]) {
        [self.view addSubview:_customNav];
        [self.view bringSubviewToFront:_customNav];
    }
    //显示当前用户姓名
    _currentNameLB = [[UILabel alloc] init];
    [self.view addSubview:_currentNameLB];
    [_currentNameLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor zheJiangBusinessRedColor]];
    _currentNameLB.textAlignment = NSTextAlignmentCenter;
    [_currentNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_customNav.mas_bottom).offset(15);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    //显示用户手机号
    _currentPhoneLB = [[UILabel alloc] init];
    [self.view addSubview:_currentPhoneLB];
    [_currentPhoneLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor zheJiangBusinessRedColor]];
    _currentPhoneLB.textAlignment = NSTextAlignmentCenter;
    [_currentPhoneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_currentNameLB.mas_bottom).offset(5);
        make.width.equalTo(@160);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    _forgetBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_forgetBT];
    [_forgetBT setTitle:@"忘记手势密码?" forState:UIControlStateNormal];
    [_forgetBT addTarget:self action:@selector(forgetGesturePassword:) forControlEvents:UIControlEventTouchUpInside];
    [_forgetBT setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
    [_forgetBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@225);
        make.height.equalTo(@30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
}















@end

