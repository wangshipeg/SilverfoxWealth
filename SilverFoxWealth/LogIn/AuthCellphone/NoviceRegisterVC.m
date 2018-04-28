//
//  NoviceRegisterVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NoviceRegisterVC.h"
#import "AddCancelButton.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "DispatchHelper.h"
#import "UMMobClick/MobClick.h"
#import "SignHelper.h"
#import "DataRequest.h"
#import "SVProgressHUD.h"
#import <AdSupport/AdSupport.h>
#import "PromptLanguage.h"
#import "AppDelegate.h"
#import "UserInfoUpdate.h"
#import "Validation.h"
#import "RoundTextField.h"
#import "SCMeasureDump.h"
#import "RegisterRebateView.h"
#import "StringHelper.h"
#import "RequestOAth.h"

@interface NoviceRegisterVC ()<UITextFieldDelegate>
@property (nonatomic, strong) RoundTextField *phoneNumTF;
@property (nonatomic, strong) RoundTextField *authCodeTF;
@property (nonatomic, strong) RoundTextField *passwordTF;
@property (nonatomic, strong) RoundCornerClickBT *registerBT;
@property (nonatomic, strong) AnewSendBT *sendBT;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation NoviceRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    // Do any additional setup after loading the view.
}

- (void)phoneNumTFCompleteInput:(UIButton *)bt {
    [self.authCodeTF becomeFirstResponder];
}

- (void)authCodeTFCompleteInput:(UIButton *)bt {
    [self.passwordTF becomeFirstResponder];
}

- (void)passwordTFCompleteInput:(UIButton *)bt {
    [self.passwordTF resignFirstResponder];
}

- (void)detectionPhoneNumTFText:(UITextField *)TF
{
    [self detectionPhoneNumTFConent];
}

- (void)detectionPhoneNumTFConent {
    if (_phoneNumTF.text.length == 11 && _passwordTF.text.length > 5 && _authCodeTF.text.length == 6) {
        self.registerBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.registerBT.userInteractionEnabled=YES;
    }else {
        self.registerBT.backgroundColor=[UIColor typefaceGrayColor];
        self.registerBT.userInteractionEnabled=NO;
    }
}

- (void)clickSendBT:(UIButton *)sender
{
    if (self.phoneNumTF.text.length < 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    if (![Validation mobileNum:self.phoneNumTF.text]) {
        [SVProgressHUD showErrorWithStatus:CellphoneNumError];
        return;
    }
    [self repeatCountDownState];
}

- (void)clickRegisterBT:(UIButton *)sender
{
    NSString *uuidStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[DataRequest sharedClient]registWithPhoneNum:self.phoneNumTF.text code:self.authCodeTF.text password:self.passwordTF.text deviceId:uuidStr channelId:@"0" invitationCellphone:@"" callback:^(id obj) {
        DLog(@"注册结果======%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                NSDictionary *dict = obj[@"data"];
                NSString *amount = dict[@"regCouponAmount"];
                [self loginWithCellphone:self.phoneNumTF.text password:self.passwordTF.text rebateAmount:amount];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
        
    }];
}

- (void)loginWithCellphone:(NSString *)rigsterCellphone password:(NSString *)password rebateAmount:(NSString *)amount{
    [[DataRequest sharedClient] loginWithCellphone:rigsterCellphone
                                          password:password
                                          callback:^(id obj)
     {
         DLog(@"注册成功登录结果==%@",obj);
         if ([obj isKindOfClass:[IndividualInfoManage class]]) {
             IndividualInfoManage *user=obj;
             [RequestOAth authenticationWithclient_id:user.cellphone response_type:@"code" callback:^(BOOL succeedState) {
                 if (succeedState) {
                     [UserInfoUpdate clearUserLocalInfo];
                     [IndividualInfoManage saveAccount:user];
                     //关联神策id
                     [[SensorsAnalyticsSDK sharedInstance] login:user.customerId];
                     [self dismissTopVC];
                     if (amount.intValue > 0)
                     {
                         [self addRegisterRebateView:amount];
                     }
                 }else{
                     DLog(@"注册授权失败");
                 }
             }];
         }
     }];
}

//添加注册红包弹框
- (void)addRegisterRebateView:(NSString *)amount {
    RegisterRebateView *rebateView=[[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:5];
    rebateView.couponAmount.attributedText=[StringHelper renderRegisterCouponAmountWith:amount valueFont:20 lastText:@"元" yuanFont:15];
    rebateView.couponType.text = @"红包";
    [rebateView showRegisterRebateView];
}

-(void)dismissTopVC{
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//开始倒计时
- (void)repeatCountDownState {
    [DispatchHelper afreshSendShortMessageWith:_sendBT];
    [self achieveSign];
}

#pragma mark-----注册短信签名*
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

//注册 或 重置密码 之 重新获取验证码
- (void)registAndResetForAfreshAchieveCheckingCodeSig:(NSString *)sig {
    [MobClick event:@"code_resend"];
    NSString *type = @"reg";
    NSString *sign_type = @"MD5";
    NSString *cellphone = self.phoneNumTF.text;
    NSDictionary *signDic=NSDictionaryOfVariableBindings(cellphone,type,sign_type);
    NSString *sign = [SignHelper  partnerSignOrder:signDic sig:sig];
    [[DataRequest sharedClient] afreshAchieveVerificationCodeWithCellphone:cellphone smsType:type sign:sign callback:^(id obj) {
        DLog(@"注册发送短信======%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=obj;
            if ([dic[@"code"] intValue] == 2000) {
                
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}


- (void)UIDecorate
{
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.navigationController.navigationBarHidden = YES;
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"注册";
    self.title = @"注册";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    weakSelf.customNav.leftViewController = ^{
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    
    _phoneNumTF = [[RoundTextField alloc] init];
    [self.view addSubview:_phoneNumTF];
    _phoneNumTF.delegate = self;
    _phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumTF.font=[UIFont systemFontOfSize:14];
    _phoneNumTF.placeholder = @"请输入手机号";
    _phoneNumTF.backgroundColor = [UIColor whiteColor];
    _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    UIView *nameTFView=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(phoneNumTFCompleteInput:) title:@"下一项"];
    [self.phoneNumTF setInputAccessoryView:nameTFView];
    
    [self.phoneNumTF addTarget:self action:@selector(detectionPhoneNumTFText:) forControlEvents:UIControlEventEditingChanged];
    [_phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(144);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    UIView *phoneLB=[AddCancelButton addTextFieldLeftViewWithImage:@"cellphoneNumber.png" width:40];
    [_phoneNumTF setLeftView:phoneLB];
    _phoneNumTF.leftViewMode=UITextFieldViewModeAlways;
    
    _authCodeTF = [[RoundTextField alloc] init];
    [self.view addSubview:_authCodeTF];
    _authCodeTF.delegate = self;
    _authCodeTF.font=[UIFont systemFontOfSize:14];
    _authCodeTF.placeholder = @"请输入验证码";
    _authCodeTF.backgroundColor = [UIColor whiteColor];
    _authCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    UIView *authCodeTFView=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(authCodeTFCompleteInput:) title:@"下一项"];
    [self.authCodeTF setInputAccessoryView:authCodeTFView];
    [self.authCodeTF addTarget:self action:@selector(detectionPhoneNumTFText:) forControlEvents:UIControlEventEditingChanged];
    [_authCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumTF.mas_bottom).offset(15);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    UIView *authCodeLB = [AddCancelButton addTextFieldLeftViewWithImage:@"authCode.png" width:40];
    [_authCodeTF setLeftView:authCodeLB];
    _authCodeTF.leftViewMode = UITextFieldViewModeAlways;
    
    _sendBT = [AnewSendBT buttonWithType:UIButtonTypeCustom];
    _sendBT.frame = CGRectMake(-10, 0, 80, 30);
    [_sendBT setTitle:@"获取短信" forState:UIControlStateNormal];
    [_sendBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    _sendBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sendBT addTarget:self action:@selector(clickSendBT:) forControlEvents:UIControlEventTouchUpInside];
    [_authCodeTF setRightView:_sendBT];
    _authCodeTF.rightViewMode = UITextFieldViewModeAlways;
    
    
    _passwordTF = [[RoundTextField alloc] init];
    [self.view addSubview:_passwordTF];
    _passwordTF.delegate = self;
    _passwordTF.font=[UIFont systemFontOfSize:14];
    _passwordTF.placeholder = @"请设置密码(6-20位数字或字母组合)";
    _passwordTF.backgroundColor=[UIColor whiteColor];
    _passwordTF.secureTextEntry = YES;
    UIView *passwordTFView=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(passwordTFCompleteInput:) title:@"完成"];
    [self.passwordTF setInputAccessoryView:passwordTFView];
    
    [self.passwordTF addTarget:self action:@selector(detectionPhoneNumTFText:) forControlEvents:UIControlEventEditingChanged];
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authCodeTF.mas_bottom).offset(15);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    UIView *passwordLB=[AddCancelButton addTextFieldLeftViewWithImage:@"passwordNumber.png" width:40];
    [_passwordTF setLeftView:passwordLB];
    _passwordTF.leftViewMode=UITextFieldViewModeAlways;
    
    _registerBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_registerBT];
    [_registerBT setTitle:@"注 册" forState:UIControlStateNormal];
    _registerBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _registerBT.backgroundColor=[UIColor typefaceGrayColor];
    _registerBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_registerBT];
    [_registerBT addTarget:self action:@selector(clickRegisterBT:) forControlEvents:UIControlEventTouchUpInside];
    [_registerBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTF.mas_bottom).offset(50);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==self.phoneNumTF) {
        if (range.location >= 11) {
            return NO;
        }
        if ([Validation oneLengthpwd:string]||[string length] == 0) {
            return YES;
        }else{
            return NO;
        }
    }
    if (textField==self.passwordTF) {
        if (range.location >= 20) {
            return NO;
        }
        if ([Validation oneLengthpwd:string]||[string length]==0) {
            return YES;
        }else{
            return NO;
        }
    }
    if (textField == self.authCodeTF) {
        if (range.location >= 6) {
            return NO;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

