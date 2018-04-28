//
//  RegisterPageVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RegisterPageVC.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import "AppDelegate.h"
#import "UserInfoUpdate.h"
#import "AnewSendBT.h"
#import "DispatchHelper.h"
#import "StringHelper.h"
#import "Validation.h"
#import "AddCancelButton.h"
#import "UMMobClick/MobClick.h"
#import "PromptLanguage.h"
#import "UILabel+LabelStyle.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import <AdSupport/AdSupport.h>
#import "SCMeasureDump.h"
#import "SignHelper.h"
#import "PhoneNumArmisticeVC.h"
#import "RegisterRebateView.h"

@interface RegisterPageVC ()
@property (strong, nonatomic) UILabel *resultTitleLB;
@property (strong, nonatomic) AnewSendBT *afreshSendBT;
@property (strong, nonatomic) UITextField *checkingTF;
@property (strong, nonatomic) UITextField *passwordTF;
@property (strong, nonatomic) RoundCornerClickBT *nextStepBT;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation RegisterPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInitialize];
    [self UIDecorate];
    [self repeatCountDownState];
}

//开始倒计时
- (void)repeatCountDownState {
    [DispatchHelper afreshSendShortMessageWith:_afreshSendBT];
}

//重新发送验证码
- (void)afreshSendCheckCode {
    
    //调接口重发验证码 包括 注册重发 和 重置密码重发
    //    [self registAndResetForAfreshAchieveCheckingCode];
    [self repeatCountDownState];
    [self achieveSign];
}
#pragma mark-----短信签名*
- (void)achieveSign {
    [[DataRequest sharedClient]requestSendSMSMD5KEYWithCallback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                NSDictionary *dict = obj[@"data"];
                NSString *resultStr = dict[@"key"];
                [self registAndResetForAfreshAchieveCheckingCodeSig:resultStr];
            }
        }
    }];
}

//重新获取验证码
- (void)registAndResetForAfreshAchieveCheckingCodeSig:(NSString *)sig {
    [MobClick event:@"code_resend"];
    NSString *type = @"resetloginpassword";
    NSString *sign_type = @"MD5";
    NSString *cellphone = self.cellPhoneStr;
    
    NSDictionary *signDic=NSDictionaryOfVariableBindings(cellphone,type,sign_type);
    NSString *sign=[SignHelper  partnerSignOrder:signDic sig:sig];
    [[DataRequest sharedClient] afreshAchieveVerificationCodeWithCellphone:cellphone smsType:type sign:sign callback:^(id obj) {
        DLog(@"重发验证码返回结果=======%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=obj;
            if ([dic[@"code"] intValue] == 2000) {
                
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}


//点击下一步按钮
- (void)nextStepWith:(UIButton *)sender {
    [self chechSecurityCode];
}

//检查验证码和密码
-(void)chechSecurityCode {
    //本地验证密码格式
    [MobClick event:@"sure_set_pwd"];
    if (self.checkingTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:[PromptLanguage pleaseInputeWith:@"验证码"]];
        return;
    }
    
    if (self.passwordTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:[PromptLanguage pleaseInputeWith:@"密码"]];
        return;
    }
    
    if (![Validation pwd:self.passwordTF.text]) {
        [SVProgressHUD showErrorWithStatus:LoginForPasswordFormatError];
        return;
    }
    
    [self retrieveLoginPassword];
}

-(void)retrieveLoginPassword {
    [[DataRequest sharedClient] retrieveLoginPasswordForSubmitNewPasswordWithPhoneNum:self.cellPhoneStr code:self.checkingTF.text password:self.passwordTF.text callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=obj;
            switch ([[dic objectForKey:@"code"] integerValue]) {
                case 2000:
                    [SVProgressHUD showInfoWithStatus:ModifiySucceed];
                    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:Wait_Time]];
//                    [self.navigationController popToRootViewControllerAnimated:NO];
//                    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{

                    }];
                    break;
                default: //否则提示错误
                    [SVProgressHUD showErrorWithStatus:LoginForCensorInput];
                    break;
            }
        }
    }];
}


#pragma -mark TextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==self.checkingTF) {
        [self.passwordTF becomeFirstResponder];
    }
    
    if (textField==self.passwordTF) {
        [self.passwordTF resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField==self.checkingTF) {
        if (range.location > 5) {
            return NO;
        }
    }
    
    if (textField==self.passwordTF) {
        
        if (range.location > 19) {
            return NO;
        }
        
        if (![Validation oneLengthpwd:string]&&[string length]!=0) {
            return NO;
        }
    }
    
    return YES;
}


- (void)detectionIdentityCardTFText:(NSNotification *)note {
    if (self.checkingTF.text.length >= 4 && self.passwordTF.text.length >= 6) {
        self.nextStepBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.nextStepBT.userInteractionEnabled=YES;
    }else{
        self.nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
        self.nextStepBT.userInteractionEnabled=NO;
    }
}

#pragma -mark 界面布置
- (void)UIDecorate {
    
    _resultTitleLB=[[UILabel alloc] init];
    [self.view addSubview:_resultTitleLB];
    _resultTitleLB.text=@"------";
    [_resultTitleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor characterBlackColor]];
    _resultTitleLB.textAlignment=NSTextAlignmentCenter;
    [_resultTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    NSString *phoneStr=[StringHelper coverUsecellPhoneWith:self.cellPhoneStr];
    self.resultTitleLB.text=[NSString stringWithFormat:@"短信验证码已发送至%@手机上",phoneStr];
    
    //验证码输入框
    _checkingTF=[[UITextField alloc] init];
    [self.view addSubview:_checkingTF];
    _checkingTF.delegate=self;
    _checkingTF.keyboardType=UIKeyboardTypeNumberPad;
    _checkingTF.font=[UIFont systemFontOfSize:13];
    _checkingTF.returnKeyType=UIReturnKeyNext;
    _checkingTF.placeholder=@"请输入您收到的验证码";
    _checkingTF.backgroundColor=[UIColor whiteColor];
    [_checkingTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom).offset(70);
        make.height.equalTo(@60);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIView *checkingCodeLB=[AddCancelButton addTextFieldLeftViewWithTitle:@"验证码" width:70];
    [_checkingTF setLeftView:checkingCodeLB];
    _checkingTF.leftViewMode=UITextFieldViewModeAlways;
    
    //重新发送按钮
    _afreshSendBT=[AnewSendBT buttonWithType:UIButtonTypeCustom];
    _afreshSendBT.frame=CGRectMake(0, 0, 100, 60);
    [_afreshSendBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    [_afreshSendBT addTarget:self action:@selector(afreshSendCheckCode) forControlEvents:UIControlEventTouchUpInside];
    _afreshSendBT.titleLabel.font=[UIFont systemFontOfSize:14];
    _afreshSendBT.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_checkingTF setRightView:_afreshSendBT];
    _checkingTF.rightViewMode=UITextFieldViewModeAlways;
    
    
    //设置密码输入框
    _passwordTF=[[UITextField alloc] init];
    [self.view addSubview:_passwordTF];
    _passwordTF.delegate=self;
    _passwordTF.returnKeyType=UIReturnKeyDone;
    _passwordTF.font=[UIFont systemFontOfSize:13];
    _passwordTF.secureTextEntry=YES;
    _passwordTF.placeholder=@"6到20位的数字或字母组合";
    _passwordTF.backgroundColor=[UIColor whiteColor];
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_checkingTF.mas_bottom).offset(20);
        make.height.equalTo(@60);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIView *setPasswordLB=[AddCancelButton addTextFieldLeftViewWithTitle:@"设置密码" width:70];
    [_passwordTF setLeftView:setPasswordLB];
    _passwordTF.leftViewMode=UITextFieldViewModeAlways;
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_button];
    [_button setTitle:@"手机号已换,收不到短信?" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:14];
    [_button addTarget:self action:@selector(handleButtonDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    _button.titleLabel.textAlignment = NSTextAlignmentRight;
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTF.mas_bottom);
        make.height.equalTo(@30);
        make.width.equalTo(@170);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    //下一步按钮
    _nextStepBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_nextStepBT];
    [_nextStepBT setTitle:@"确定" forState:UIControlStateNormal];
    _nextStepBT.titleLabel.font=[UIFont systemFontOfSize:16];
    [FastAnimationAdd codeBindAnimation:_nextStepBT];
    _nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
    _nextStepBT.userInteractionEnabled=NO;
    [_nextStepBT addTarget:self action:@selector(nextStepWith:) forControlEvents:UIControlEventTouchUpInside];
    [_nextStepBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTF.mas_bottom).offset(30);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
}

- (void)handleButtonDoSomething:(UIButton *)sender
{
    PhoneNumArmisticeVC *phoneArmisticeVC = [[PhoneNumArmisticeVC alloc] init];
    [self.navigationController pushViewController:phoneArmisticeVC animated:YES];
}

- (void)dataInitialize {
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"找回密码";
    self.title = @"找回密码";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.checkingTF becomeFirstResponder];
    //实时检测用户输入状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionIdentityCardTFText:) name:UITextFieldTextDidChangeNotification object:nil];
}








@end

