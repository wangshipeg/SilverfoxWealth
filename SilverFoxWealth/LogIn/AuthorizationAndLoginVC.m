//
//  AuthorizationAndLoginVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AuthorizationAndLoginVC.h"
#import "AddCancelButton.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "UMMobClick/MobClick.h"
#import "SVProgressHUD.h"
#import "PromptLanguage.h"
#import "Validation.h"
#import "DataRequest.h"
#import "SCMeasureDump.h"
#import "JPUSHService.h"
#import "AppDelegate.h"
#import "GesturePasswordVC.h"
#import "UserInfoUpdate.h"
#import "EntryPhoneNumberVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSAuthDetailViewController.h"
#import <UShareUI/UMSocialUIUtility.h>
#import "NoviceRegisterVC.h"
#import "AuthBindingCellphoneVC.h"
#import "RoundTextField.h"
#import "VCAppearManager.h"
#import "RequestOAth.h"

@interface AuthorizationAndLoginVC ()<UITextFieldDelegate>
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (strong, nonatomic) RoundTextField *phoneNumTF;
@property (nonatomic, strong) RoundTextField *passwordTF;
@property (strong, nonatomic) UIButton *nextStepBT;
@property (nonatomic, strong) UIButton *registerBT;
@property (nonatomic, strong) UIButton *forgetPasswordBT;
@property (nonatomic, strong) UIButton *wxLoginBT;
@property (nonatomic, strong) UIButton *qqLoginBT;

@property (nonatomic, strong) UIButton *agreementBT;//用户协议
@end

@implementation AuthorizationAndLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UIDecorate];
    // Do any additional setup after loading the view.
}

- (void)phoneNumTFCompleteInput:(UIButton *)bt {
    [self.passwordTF becomeFirstResponder];
}

- (void)passwordTFCompleteInput:(UIButton *)bt {
    [self.passwordTF resignFirstResponder];
}


- (void)detectionPhoneNumTFText:(UITextField *)TF {
    if (self.phoneNumTF.text.length != 0) {
        self.phoneNumTF.rightView.hidden=NO;
    }else{
        self.phoneNumTF.rightView.hidden=YES;
    }
    [self detectionPhoneNumTFConent];
}

- (void)detectionpasswordTFText:(UITextField *)TF {
    if (self.passwordTF.text.length != 0) {
        self.passwordTF.rightView.hidden=NO;
    }else{
        self.passwordTF.rightView.hidden=YES;
    }
    [self detectionPhoneNumTFConent];
}

- (void)detectionPhoneNumTFConent {
    if (_phoneNumTF.text.length==11 && _passwordTF.text.length > 5) {
        self.nextStepBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.nextStepBT.userInteractionEnabled=YES;
    }else {
        self.nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
        self.nextStepBT.userInteractionEnabled=NO;
    }
}

- (void)nextAndForgetPassword:(UIButton *)sender
{
    [MobClick event:@"click_login"];
    [self.passwordTF resignFirstResponder];
    if (![Validation mobileNum:self.phoneNumTF.text]) {
        [SVProgressHUD showErrorWithStatus:CellphoneNumError];
        return;
    }
    
    if (![Validation pwd:self.passwordTF.text]){
        [SVProgressHUD showErrorWithStatus:LoginForPasswordFormatError];
        return;
    }
    [[DataRequest sharedClient] loginWithCellphone:self.phoneNumTF.text
                                          password:self.passwordTF.text
                                          callback:^(id obj)
     {
         DLog(@"登录结果==%@",obj);
         [SCMeasureDump shareSCMeasureDump].userOfObj = obj;
         if ([obj isKindOfClass:[IndividualInfoManage class]]) {
             IndividualInfoManage *indivi=obj;
             [RequestOAth authenticationWithclient_id:indivi.cellphone response_type:@"code" callback:^(BOOL succeedState) {
                 if (succeedState) {
                     [self.passwordTF resignFirstResponder];
                     [self loginFinishWith:indivi];
                 }
                 if (!succeedState) {
                     DLog(@"登录授权失败");
                 }
             }];
         }
         if ([obj isKindOfClass:[NSDictionary class]]) {
             [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
         }
     }];
}

//登录成功
-(void)loginFinishWith:(IndividualInfoManage *)user {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"login_pwd_ensure_btn" object:self];

    if ([self.navigationController.topViewController.presentingViewController class] == [GesturePasswordVC class]) {
        IndividualInfoManage *currentUser=[IndividualInfoManage currentAccount];
        if (![user.customerId isEqualToString:currentUser.customerId]) {
            [SVProgressHUD showErrorWithStatus:WrongLoginPasswordVerify];
            return;
        }
        [IndividualInfoManage  updateAccountWith:user];
        [self dismissViewControllerAnimated:YES completion:nil];
        GesturePasswordVC *gestureVC=(GesturePasswordVC *)self.navigationController.topViewController.presentingViewController;
        [gestureVC retrieveGesturePasswordFinish];
        return;
    }
    [UserInfoUpdate clearUserLocalInfo];
    [IndividualInfoManage  saveAccount:user];
    [self.passwordTF resignFirstResponder];
    [self sendUserLoginSuccessDataRequest];
    //关联神策id
    [[SensorsAnalyticsSDK sharedInstance] login:user.customerId];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)sendUserLoginSuccessDataRequest{
    //登录成功,告诉极光,设置推送别名
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (user.customerId) {
        [JPUSHService setAlias:user.customerId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:1];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==self.phoneNumTF) {
        if (range.location >= 11) {
            return NO;
        }
        if ([Validation oneLengthpwd:string]||[string length]==0) {
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
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_phoneNumTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
}

- (void)UIDecorate
{
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"登录";
    self.title = @"登录";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    weakSelf.customNav.leftViewController = ^{
        [weakSelf.phoneNumTF resignFirstResponder];
        [weakSelf.passwordTF resignFirstResponder];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    _phoneNumTF = [[RoundTextField alloc] init];
    [self.view addSubview:_phoneNumTF];
    _phoneNumTF.delegate = self;
    _phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumTF.font=[UIFont systemFontOfSize:14];
    _phoneNumTF.placeholder = @"请输入手机号";
    _phoneNumTF.backgroundColor = [UIColor whiteColor];
    _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    UIView *nameTFView = [AddCancelButton addCompleteBTOnVC:self withSelector:@selector(phoneNumTFCompleteInput:) title:@"下一项"];
    [self.phoneNumTF setInputAccessoryView:nameTFView];
    
    [self.phoneNumTF addTarget:self action:@selector(detectionPhoneNumTFText:) forControlEvents:UIControlEventEditingChanged];
    [_phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom).offset(80);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    UIView *phoneLB=[AddCancelButton addTextFieldLeftViewWithImage:@"cellphoneNumber.png" width:40];
    [_phoneNumTF setLeftView:phoneLB];
    _phoneNumTF.leftViewMode=UITextFieldViewModeAlways;
    
    _passwordTF = [[RoundTextField alloc] init];
    [self.view addSubview:_passwordTF];
    _passwordTF.delegate = self;
    _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTF.font = [UIFont systemFontOfSize:14];
    _passwordTF.placeholder = @"请输入密码";
    _passwordTF.secureTextEntry = YES;
    _passwordTF.backgroundColor = [UIColor whiteColor];
    UIView *passwordTFView = [AddCancelButton addCompleteBTOnVC:self withSelector:@selector(passwordTFCompleteInput:) title:@"完成"];
    [self.passwordTF setInputAccessoryView:passwordTFView];
    [self.passwordTF addTarget:self action:@selector(detectionpasswordTFText:) forControlEvents:UIControlEventEditingChanged];
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumTF.mas_bottom).offset(15);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    UIView *passwordLB = [AddCancelButton addTextFieldLeftViewWithImage:@"passwordNumber.png" width:40];
    [_passwordTF setLeftView:passwordLB];
    _passwordTF.leftViewMode = UITextFieldViewModeAlways;
    
    _nextStepBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_nextStepBT];
    [_nextStepBT setTitle:@"登录" forState:UIControlStateNormal];
    _nextStepBT.titleLabel.font = [UIFont systemFontOfSize:16];
    _nextStepBT.backgroundColor = [UIColor typefaceGrayColor];
    _nextStepBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_nextStepBT];
    [_nextStepBT addTarget:self action:@selector(nextAndForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [_nextStepBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTF.mas_bottom).offset(50);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    
    
    //忘记密码
    _forgetPasswordBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgetPasswordBT setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgetPasswordBT setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
    _forgetPasswordBT.titleLabel.font=[UIFont systemFontOfSize:16];
    [_forgetPasswordBT addTarget:self action:@selector(forgetLoginPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPasswordBT];
    [_forgetPasswordBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nextStepBT.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.right.equalTo(_nextStepBT.mas_right);
    }];
    
    //新用户注册
    _registerBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBT setTitle:@"新用户注册" forState:UIControlStateNormal];
    [_registerBT setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
    _registerBT.titleLabel.font=[UIFont systemFontOfSize:16];
    [_registerBT addTarget:self action:@selector(registerNumberBT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBT];
    [_registerBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nextStepBT.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.left.equalTo(_nextStepBT.mas_left);
    }];
    
    //
    _wxLoginBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wxLoginBT setBackgroundImage:[UIImage imageNamed:@"wechatAuth.png"] forState:UIControlStateNormal];
    [_wxLoginBT addTarget:self action:@selector(clickAuthLoginBT:) forControlEvents:UIControlEventTouchUpInside];
    _wxLoginBT.tag = 100;
    [self.view addSubview:_wxLoginBT];
    [_wxLoginBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-120);
        make.height.equalTo(@45);
        make.width.equalTo(@45);
        make.left.equalTo(self.view.mas_centerX).offset(15);
    }];
    
    _qqLoginBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_qqLoginBT setBackgroundImage:[UIImage imageNamed:@"authQQ.png"] forState:UIControlStateNormal];
    [_qqLoginBT addTarget:self action:@selector(clickAuthLoginBT:) forControlEvents:UIControlEventTouchUpInside];
    _qqLoginBT.tag = 101;
    [self.view addSubview:_qqLoginBT];
    [_qqLoginBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-120);
        make.height.equalTo(@45);
        make.width.equalTo(@45);
        make.right.equalTo(self.view.mas_centerX).offset(-15);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.text = @"第三方登录";
    label.textColor = [UIColor typefaceGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.qqLoginBT.mas_top).offset(-25);
        make.height.equalTo(@15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel *lineLB = [[UILabel alloc] init];
    [self.view addSubview:lineLB];
    lineLB.backgroundColor = [UIColor typefaceGrayColor];
    [lineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.height.equalTo(@1);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(label.mas_left).offset(-15);
    }];
    
    UILabel *righeLineLB = [[UILabel alloc] init];
    [self.view addSubview:righeLineLB];
    righeLineLB.backgroundColor = [UIColor typefaceGrayColor];
    [righeLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.height.equalTo(@1);
        make.right.equalTo(self.view.mas_right).offset(-43);
        make.left.equalTo(label.mas_right).offset(15);
    }];
    
    _agreementBT  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreementBT addTarget:self action:@selector(clickAgreementBT:) forControlEvents:UIControlEventTouchUpInside];
    [_agreementBT setTitle:@"银狐财富用户服务协议" forState:UIControlStateNormal];
    [_agreementBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    _agreementBT.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_agreementBT];
    [_agreementBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-45);
        make.height.equalTo(@15);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
    }];
}
- (void)clickAgreementBT:(UIButton *)sender
{
    [MobClick event:@"click_user_service_agreement"];
    [VCAppearManager pushH5VCWithCurrentVC:self workS:accountServiceAgreement];
}

- (void)clickAuthLoginBT:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    UMSAuthInfo *obj = [UMSAuthInfo objectWithType:UMSocialPlatformType_WechatSession];
    UMSAuthInfo *obj1 = [UMSAuthInfo objectWithType:UMSocialPlatformType_QQ];
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:obj.platform completion:^(id result, NSError *error) {
        if (sender.tag == 100) {
            [MobClick event:@"click_qq_login"];
            [weakSelf authForPlatform:obj];
        }
        if (sender.tag == 101) {
            [MobClick event:@"click_wx_login"];
            [weakSelf authForPlatform:obj1];
        }
    }];
}

- (void)authForPlatform:(UMSAuthInfo *)authInfo
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:authInfo.platform currentViewController:nil completion:^(id result, NSError *error) {
        if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
            UMSocialUserInfoResponse *resp = result;
            authInfo.response = resp;
            NSString *categoryStr = nil;
            NSString *uidStr = nil;
            if (authInfo.platform == 1) {
                categoryStr = @"1";
            }else if (authInfo.platform == 4)
            {
                categoryStr = @"0";
            }
            uidStr = resp.unionId;
            [self umSocialUserInfoResponseData:categoryStr openid:uidStr nickName:resp.name headImg:resp.iconurl authInfo:authInfo];
        }
    }];
}

- (void)umSocialUserInfoResponseData:(NSString *)categoryStr openid:(NSString *)unionId nickName:(NSString *)name headImg:(NSString *)iconurl authInfo:(UMSAuthInfo *)authInfo
{
    [[DataRequest sharedClient] thirdAuthorisationLoginCategory:categoryStr openId:unionId nickName:name headImg:iconurl callback:^(id obj) {
        NSLog(@"授权 登录结果====%@",obj);
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *indivi=obj;
            [RequestOAth authenticationWithclient_id:indivi.cellphone response_type:@"code" callback:^(BOOL succeedState) {
                if (succeedState) {
                    [self loginFinishWith:indivi];
                }
                if (!succeedState) {
                    [SVProgressHUD showWithStatus:@"授权失败"];
                }
            }];
        }
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 9971) {
                [self bindingCellphoneAuthInfo:authInfo category:categoryStr];
            } else {
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (void) bindingCellphoneAuthInfo:(UMSAuthInfo *)authInfo category:(NSString *)categoryStr
{
    AuthBindingCellphoneVC *VC = [[AuthBindingCellphoneVC alloc] init];
    VC.authInfo = authInfo;
    VC.category = categoryStr;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)forgetLoginPassword:(UIButton *)sender
{
    [MobClick event:@"forget_pwd_btn_click"];
    EntryPhoneNumberVC *phoneVC = [[EntryPhoneNumberVC alloc] init];
    UINavigationController *entry = [[UINavigationController alloc] initWithRootViewController:phoneVC];
    [self presentViewController:entry animated:YES completion:nil];
}

- (void)registerNumberBT:(UIButton *)sender
{
    [MobClick event:@"login_user_register_click"];
    [[SensorsAnalyticsSDK sharedInstance] track:@"ClickRegister"
                                 withProperties:@{
                                                  @"RegisterChannel" : @"iOS",
                                                  }];
    NoviceRegisterVC *registerVC = [[NoviceRegisterVC alloc] init];
    registerVC.navigationController.navigationBarHidden = YES;
    UINavigationController *entry = [[UINavigationController alloc] initWithRootViewController:registerVC];
    [self presentViewController:entry animated:YES completion:nil];
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

