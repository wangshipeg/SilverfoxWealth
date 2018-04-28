

#import "EntryPhoneNumberVC.h"
#import "RegisterPageVC.h"
#import "DataRequest.h"
#import "AddCancelButton.h"
#import "EntryIdentityCardVC.h"
#import "CommunalInfo.h"
#import "Validation.h"
#import <SVProgressHUD.h>
#import "UMMobClick/MobClick.h"
#import "PromptLanguage.h"
#import "UILabel+LabelStyle.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "SCMeasureDump.h"
#import "SignHelper.h"
#import "SCMeasureDump.h"

@interface EntryPhoneNumberVC ()
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (strong, nonatomic) UITextField *phoneNumTF;
@property (strong, nonatomic) UIButton *nextStepBT;

@end

@implementation EntryPhoneNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
}

- (void)detectionPhoneNumTFText:(UITextField *)TF {
    if (self.phoneNumTF.text.length != 0) {
        self.phoneNumTF.rightView.hidden=NO;
    }else{
        self.phoneNumTF.rightView.hidden=YES;
    }
    [self detectionPhoneNumTFConent];
}

- (void)detectionPhoneNumTFConent {
    
    if (_phoneNumTF.text.length==11) {
        self.nextStepBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.nextStepBT.userInteractionEnabled=YES;
    }else {
        self.nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
        self.nextStepBT.userInteractionEnabled=NO;
    }
}

- (void)nextAndForgetPassword:(UIButton *)sender {
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

- (void)loginNextStep:(NSString *)sig {
    [MobClick event:@"cellphone_input_next_btn"];
    if (self.phoneNumTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:[PromptLanguage pleaseInputeWith:@"手机号码"]];
        return;
    }
    
    if (![Validation mobileNum:self.phoneNumTF.text]) {
        [SVProgressHUD showErrorWithStatus:CellphoneNumError];
        return;
    }
    
    [[DataRequest sharedClient] provingCustomerStatusAndAchieveCheckingCodeWithCellphone:self.phoneNumTF.text callback:^(id obj) {
        DLog(@"验证手机号结果==2==%@",obj);
        [self confirmNextStepWith:obj];
    }];
}

//根据加载结果确定页面下一步走向
-(void)confirmNextStepWith:(id)obj {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = obj;
        if ([dic[@"code"] intValue] == 2000) {
            NSDictionary *dict = dic[@"data"];
            NSString *customer = dict[@"isCustomer"];
            if ([customer integerValue] == 0) { //如果不是投资客 直接发送短信 进入重置密码页
                [SCMeasureDump shareSCMeasureDump].isCustomer = NO;
                [self achieveTSign];
            }else { //如果是投资客 进入 输入身份证的页面
                [SCMeasureDump shareSCMeasureDump].isCustomer = YES;
                [self goToEntryIdentityCardNumPage];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
        }
    }
}
#pragma mark-----签名*
- (void)achieveTSign {
    [[DataRequest sharedClient]requestSendSMSMD5KEYWithCallback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                NSDictionary *dict = obj[@"data"];
                NSString *resultStr = dict[@"key"];
                [self resetPasswordAchieveCheckingCode:resultStr];
            }
        }
    }];
}

#pragma -mark 忘记密码 相关
//进入输入身份证号码页面
-(void)goToEntryIdentityCardNumPage
{
    EntryIdentityCardVC *identity=[[EntryIdentityCardVC alloc] init];
    identity.phoneNumStr=_phoneNumTF.text;
    [self.navigationController pushViewController:identity animated:YES];
}

//重置登录密码 之 发送短信
-(void)resetPasswordAchieveCheckingCode:(NSString *)sig {
    NSString *idcard = @"";
    NSString *sign_type = @"MD5";
    NSString *cellphone = self.phoneNumTF.text;
    NSString *type = @"resetloginpassword";
    NSDictionary *signDic=NSDictionaryOfVariableBindings(cellphone,idcard,sign_type,type);
    NSString *sign=[SignHelper  partnerSignOrder:signDic sig:sig];
    [[DataRequest sharedClient] retrieveLoginPasswordForSendNoteWithCellphone:self.phoneNumTF.text idcard:@"" sign:sign callback:^(id obj) {
        DLog(@"重置密码 发送短信结果==%@",obj);
        //无论成功与否 都进入 重置密码页面
        [self goToRetrievePasswordPage];
    }];
}

//忘记密码 直接发送验证码 重设密码
- (void)goToRetrievePasswordPage {
    RegisterPageVC *regi=[[RegisterPageVC alloc] init];
    regi.cellPhoneStr=self.phoneNumTF.text;
    regi.workStatus = RetrievePasswordState;//找回密码
    [self.navigationController pushViewController:regi animated:YES];
    
}

#pragma -mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self nextAndForgetPassword:nil];
    return YES;
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [self detectionPhoneNumTFConent];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location>=11) {
        return NO;
    }
    return YES;
}

- (void)UIDecorate {
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.navigationController.navigationBarHidden = YES;
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"手机号";
    self.title = @"手机号";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    weakSelf.customNav.leftViewController = ^{
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    
    _phoneNumTF = [[UITextField alloc] init];
    [self.view addSubview:_phoneNumTF];
    _phoneNumTF.delegate = self;
    _phoneNumTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _phoneNumTF.font=[UIFont systemFontOfSize:14];
    _phoneNumTF.placeholder=@"请输入手机号找回密码";
    _phoneNumTF.backgroundColor=[UIColor whiteColor];
    _phoneNumTF.keyboardType=UIKeyboardTypeDecimalPad;
    
    [self.phoneNumTF addTarget:self action:@selector(detectionPhoneNumTFText:) forControlEvents:UIControlEventEditingChanged];
    [_phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom).offset(20);
        make.height.equalTo(@60);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIView *phoneLB=[AddCancelButton addTextFieldLeftViewWithTitle:@"手机号" width:60];
    [_phoneNumTF setLeftView:phoneLB];
    _phoneNumTF.leftViewMode=UITextFieldViewModeAlways;
    
    
    _nextStepBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_nextStepBT];
    [_nextStepBT setTitle:@"下一步" forState:UIControlStateNormal];
    _nextStepBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
    _nextStepBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_nextStepBT];
    [_nextStepBT addTarget:self action:@selector(nextAndForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [_nextStepBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneNumTF.mas_bottom).offset(40);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
}





@end

