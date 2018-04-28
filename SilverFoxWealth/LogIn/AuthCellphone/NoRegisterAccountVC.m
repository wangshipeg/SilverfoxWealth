//
//  NoRegisterAccountVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NoRegisterAccountVC.h"
#import "AddCancelButton.h"
#import "AnewSendBT.h"
#import "Validation.h"
#import "DispatchHelper.h"
#import "UMMobClick/MobClick.h"
#import "SVProgressHUD.h"
#import "PromptLanguage.h"
#import "SignHelper.h"
#import "DataRequest.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import <AdSupport/AdSupport.h>
#import "JPUSHService.h"
#import "AppDelegate.h"
#import "UserInfoUpdate.h"
#import "RoundTextField.h"
#import "SCMeasureDump.h"
#import "RegisterRebateView.h"
#import "StringHelper.h"
#import "WithoutAuthorization.h"
#import "RequestOAth.h"
@interface NoRegisterAccountVC ()<UITextFieldDelegate>

@property (nonatomic, strong) RoundTextField *phoneNumTF;
@property (nonatomic, strong) RoundTextField *authCodeTF;
@property (nonatomic, strong) AnewSendBT *sendBT;
@property (nonatomic, strong) RoundCornerClickBT *bindingBT;

@end

@implementation NoRegisterAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    [self repeatCountDownState];
    // Do any additional setup after loading the view.
}

//重新开始倒计时
- (void)repeatCountDownState {
    [DispatchHelper afreshSendShortMessageWith:_sendBT];
}
- (void)clickSendBT:(UIButton *)sender
{
    [self repeatCountDownState];
    [self achieveSign];
}
#pragma mark-----注册短信签名*
- (void)achieveSign {
    [[DataRequest sharedClient]requestSendSMSMD5KEYWithCallback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                NSDictionary *dict = obj[@"data"];
                NSString *resultStr = dict[@"key"];
                [self loginNextStep:resultStr];
            }
        }
    }];
}

#pragma -mark 注册相关
- (void)loginNextStep:(NSString *)sig {
    [MobClick event:@"cellphone_input_next_btn"];
    if (![Validation mobileNum:self.phoneNumTF.text]) {
        [SVProgressHUD showErrorWithStatus:CellphoneNumError];
        return;
    }
    NSString *type = @"reg";
    NSString *sign_type = @"MD5";
    NSString *cellphone = self.phoneNumTF.text;
    NSDictionary *signDic = NSDictionaryOfVariableBindings(cellphone,type,sign_type);
    NSString *sign=[SignHelper  partnerSignOrder:signDic sig:sig];
    [[DataRequest sharedClient] afreshAchieveVerificationCodeWithCellphone:cellphone smsType:type sign:sign callback:^(id obj) {
        DLog(@"验证手机号结果====%@",obj);
        [self confirmNextStepWith:obj];
    }];
}

//根据加载结果确定页面下一步走向
-(void)confirmNextStepWith:(id)obj {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic=obj;
        if ([dic[@"code"] intValue] == 2000) {
            
        }else{
            [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
        }
    }
}

- (void)clickBindingBT:(UIButton *)sender
{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *uidStr = nil;
    uidStr = _authInfo.response.unionId;
    
    [[DataRequest sharedClient]thirdAuthorisationLoginWithUesrCellphone:_phoneStr code:_authCodeTF.text category:_category channelId:@"0" openId:uidStr nickName:_authInfo.response.name headImg:_authInfo.response.iconurl deviceUUID:idfa callback:^(id obj) {
        DLog(@"第三方注册绑定返回结果======%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *rebateAmountStr = nil;
            if ([obj[@"code"] integerValue]==2000) {
                NSDictionary *dict = obj[@"data"];
                rebateAmountStr = dict[@"regCouponAmount"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"login_pwd_ensure_btn" object:self];
                [self loginFinishWithCategory:_category openId:uidStr rebateAmount:rebateAmountStr nickName:_authInfo.response.name headImg:_authInfo.response.iconurl];
            } else {
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

//登录成功 thirdAuthorisationLoginCategory
-(void)loginFinishWithCategory:(NSString *)category openId:(NSString *)uid rebateAmount:(NSString *)amount nickName:(NSString *)nickName headImg:(NSString *)headImg{
    [[DataRequest sharedClient]thirdAuthorisationLoginCategory:category openId:uid nickName:nickName headImg:headImg callback:^(id obj) {
        DLog(@"第三方注册页面登录结果1==%@",obj);
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *user=obj;
            [RequestOAth authenticationWithclient_id:user.cellphone response_type:@"code" callback:^(BOOL succeedState) {
                if (succeedState) {
                    [UserInfoUpdate clearUserLocalInfo];
                    [IndividualInfoManage saveAccount:user];
                    //关联神策id
                    [[SensorsAnalyticsSDK sharedInstance] login:user.customerId];
                    [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:^{
                    }];
                    if (amount.intValue > 0)
                    {
                        [self addRegisterRebateView:amount];
                    }
                }
                //请求错误
                if (!succeedState) {
                    DLog(@"第三方注册授权失败");
                }
            }];
        }else if([obj isKindOfClass:[NSDictionary class]]) {
            [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
        }
    }];
}

//添加注册红包弹框
- (void)addRegisterRebateView:(NSString *)rebateAmount {
    RegisterRebateView *rebateView=[[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:5];
    rebateView.couponAmount.attributedText=[StringHelper renderRegisterCouponAmountWith:rebateAmount valueFont:20 lastText:@"元" yuanFont:16];
    rebateView.couponType.text = @"红包";
    [rebateView showRegisterRebateView];
}

- (void)sendUserLoginSuccessDataRequest{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    DLog(@"极光推送别名...======%@",user.customerId);
    if (user.customerId) {
        [JPUSHService setAlias:user.customerId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:1];
    }
}

- (void)UIDecorate
{
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"验证手机号";
    self.title = @"验证手机号";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
    _phoneNumTF=[[RoundTextField alloc] init];
    [self.view addSubview:_phoneNumTF];
    _phoneNumTF.font=[UIFont systemFontOfSize:14];
    _phoneNumTF.text = _phoneStr;
    _phoneNumTF.userInteractionEnabled = NO;
    _phoneNumTF.backgroundColor=[UIColor whiteColor];
    _phoneNumTF.keyboardType=UIKeyboardTypeDecimalPad;
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
    _authCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _authCodeTF.font=[UIFont systemFontOfSize:14];
    _authCodeTF.placeholder = @"请输入验证码";
    _authCodeTF.backgroundColor=[UIColor whiteColor];
    _authCodeTF.keyboardType=UIKeyboardTypeDecimalPad;
    UIView *authCodeTFView=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(authCodeTFCompleteInput:) title:@"完成"];
    [self.authCodeTF setInputAccessoryView:authCodeTFView];
    [_authCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumTF.mas_bottom).offset(15);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    [self.authCodeTF addTarget:self action:@selector(detectionPhoneNumTFText:) forControlEvents:UIControlEventEditingChanged];
    UIView *authCodeLB=[AddCancelButton addTextFieldLeftViewWithImage:@"authCode.png" width:40];
    [_authCodeTF setLeftView:authCodeLB];
    _authCodeTF.leftViewMode=UITextFieldViewModeAlways;
    
    _sendBT = [AnewSendBT buttonWithType:UIButtonTypeCustom];
    [_sendBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    _sendBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sendBT addTarget:self action:@selector(clickSendBT:) forControlEvents:UIControlEventTouchUpInside];
    _sendBT.frame=CGRectMake(-10, 0, 100, 30);
    [_authCodeTF setRightView:_sendBT];
    _authCodeTF.rightViewMode=UITextFieldViewModeAlways;
    
    _bindingBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_bindingBT];
    [_bindingBT setTitle:@"绑定" forState:UIControlStateNormal];
    _bindingBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _bindingBT.backgroundColor=[UIColor typefaceGrayColor];
    _bindingBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_bindingBT];
    [_bindingBT addTarget:self action:@selector(clickBindingBT:) forControlEvents:UIControlEventTouchUpInside];
    [_bindingBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_authCodeTF.mas_bottom).offset(50);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==self.authCodeTF) {
        if (range.location >= 6) {
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

- (void)detectionPhoneNumTFText:(UITextField *)TF {
    [self detectionPhoneNumTFConent];
}

- (void)detectionPhoneNumTFConent {
    if (_authCodeTF.text.length == 6) {
        self.bindingBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.bindingBT.userInteractionEnabled=YES;
    } else {
        self.bindingBT.backgroundColor=[UIColor typefaceGrayColor];
        self.bindingBT.userInteractionEnabled=NO;
    }
}

- (void)authCodeTFCompleteInput:(UIButton *)sender
{
    [self.authCodeTF resignFirstResponder];
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

