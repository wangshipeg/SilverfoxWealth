//
//  HaveCellpneForBindingAuthVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HaveCellpneForBindingAuthVC.h"
#import "AddCancelButton.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "Validation.h"
#import "DataRequest.h"
#import "UserInfoUpdate.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "RoundTextField.h"
#import "RequestOAth.h"

@interface HaveCellpneForBindingAuthVC ()<UITextFieldDelegate>

@property (nonatomic, strong) RoundTextField *passwordTF;
@property (nonatomic, strong) RoundTextField *phoneNumTF;
@property (nonatomic, strong) RoundCornerClickBT *bindingBT;

@end

@implementation HaveCellpneForBindingAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    // Do any additional setup after loading the view.
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
    
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.text = @"该手机号已注册,请验证账号信息";
    label.textColor = [UIColor characterBlackColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(144);
        make.height.equalTo(@15);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right);
    }];
    
    _phoneNumTF=[[RoundTextField alloc] init];
    [self.view addSubview:_phoneNumTF];
    _phoneNumTF.font=[UIFont systemFontOfSize:14];
    _phoneNumTF.text = _phoneStr;
    _phoneNumTF.userInteractionEnabled = NO;
    _phoneNumTF.backgroundColor=[UIColor whiteColor];
    _phoneNumTF.keyboardType=UIKeyboardTypeDecimalPad;
    [_phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(30);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    UIView *phoneLB=[AddCancelButton addTextFieldLeftViewWithImage:@"cellphoneNumber.png" width:40];
    [_phoneNumTF setLeftView:phoneLB];
    _phoneNumTF.leftViewMode=UITextFieldViewModeAlways;
    
    _passwordTF = [[RoundTextField alloc] init];
    [self.view addSubview:_passwordTF];
    _passwordTF.delegate=self;
    _passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordTF.font=[UIFont systemFontOfSize:14];
    _passwordTF.placeholder=@"请输入密码";
    _passwordTF.secureTextEntry=YES;
    _passwordTF.backgroundColor=[UIColor whiteColor];
    UIView *passwordTFView=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(passwordTFCompleteInput:) title:@"完成"];
    [self.passwordTF setInputAccessoryView:passwordTFView];
    [self.passwordTF addTarget:self action:@selector(detectionpasswordTFText:) forControlEvents:UIControlEventEditingChanged];
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumTF.mas_bottom).offset(15);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    UIView *passwordLB=[AddCancelButton addTextFieldLeftViewWithImage:@"passwordNumber.png" width:40];
    [_passwordTF setLeftView:passwordLB];
    _passwordTF.leftViewMode=UITextFieldViewModeAlways;
    
    _bindingBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_bindingBT];
    [_bindingBT setTitle:@"绑定" forState:UIControlStateNormal];
    _bindingBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _bindingBT.backgroundColor=[UIColor typefaceGrayColor];
    _bindingBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_bindingBT];
    [_bindingBT addTarget:self action:@selector(clickBindingBT:) forControlEvents:UIControlEventTouchUpInside];
    [_bindingBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTF.mas_bottom).offset(50);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
}

- (void)clickBindingBT:(UIButton *)sender
{
    NSString *uidOrOpenIdStr = nil;
    uidOrOpenIdStr = _authInfo.response.unionId;
    [[DataRequest sharedClient]thirdAuthorisationLoginWithCustomerCellphone:_phoneNumTF.text password:_passwordTF.text category:_category openId:uidOrOpenIdStr nickName:_authInfo.response.name headImg:_authInfo.response.iconurl login:@"0" callback:^(id obj) {
        DLog(@"第三方授权绑定结果=====%@",obj);
        //如果返回的是user类 说明登录成功 保存用户信息 退出用户登录页面
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login_pwd_ensure_btn" object:self];
            IndividualInfoManage *indivi=obj;
            [RequestOAth authenticationWithclient_id:indivi.cellphone response_type:@"code" callback:^(BOOL succeedState) {
                if (succeedState) {
                    [self loginFinishWith:indivi];
                }else{
                    DLog(@"第三方登录绑定已注册手机号授权失败");
                }
            }];
            
        } else if ([obj isKindOfClass:[NSDictionary class]]){
            [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
        } else {
            [SVProgressHUD showErrorWithStatus:@"绑定失败"];
        }
    }];
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
        self.bindingBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.bindingBT.userInteractionEnabled=YES;
    }else {
        self.bindingBT.backgroundColor=[UIColor typefaceGrayColor];
        self.bindingBT.userInteractionEnabled=NO;
    }
}


//登录成功
-(void)loginFinishWith:(IndividualInfoManage *)user {
    [UserInfoUpdate clearUserLocalInfo];
    [IndividualInfoManage  saveAccount:user];
    [self.passwordTF resignFirstResponder];
    [self sendUserLoginSuccessDataRequest];
    //关联神策id
    [[SensorsAnalyticsSDK sharedInstance] login:user.customerId];
    [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:^{
        
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


- (void)passwordTFCompleteInput:(UIButton *)sender
{
    [self.passwordTF resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        self.view = nil;
    }
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

