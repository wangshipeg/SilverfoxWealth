//
//  AuthBindingCellphoneVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AuthBindingCellphoneVC.h"
#import "AddCancelButton.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "HaveCellpneForBindingAuthVC.h"
#import "DataRequest.h"
#import "UMMobClick/MobClick.h"
#import "Validation.h"
#import "SVProgressHUD.h"
#import "PromptLanguage.h"
#import "SignHelper.h"
#import "NoRegisterAccountVC.h"
#import "RoundTextField.h"
#import "SCMeasureDump.h"

@interface AuthBindingCellphoneVC ()<UITextFieldDelegate>

@property (nonatomic, strong) RoundTextField *phoneNumTF;
@property (nonatomic, strong) RoundCornerClickBT *nextStepBT;

@end

@implementation AuthBindingCellphoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    // Do any additional setup after loading the view.
}

- (void)UIDecorate
{
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"绑定手机号";
    self.title = @"绑定手机号";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
    _phoneNumTF=[[RoundTextField alloc] init];
    [self.view addSubview:_phoneNumTF];
    _phoneNumTF.delegate = self;
    _phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumTF.font=[UIFont systemFontOfSize:14];
    _phoneNumTF.placeholder = @"请输入手机号";
    _phoneNumTF.backgroundColor=[UIColor whiteColor];
    _phoneNumTF.keyboardType=UIKeyboardTypeDecimalPad;
    UIView *nameTFView=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(phoneNumTFCompleteInput:) title:@"完成"];
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
    
    _nextStepBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_nextStepBT];
    [_nextStepBT setTitle:@"下一步" forState:UIControlStateNormal];
    _nextStepBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
    _nextStepBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_nextStepBT];
    [_nextStepBT addTarget:self action:@selector(nextAndForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [_nextStepBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneNumTF.mas_bottom).offset(50);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
}

- (void)nextAndForgetPassword:(UIButton *)sender
{
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

#pragma -mark 登陆相关
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
        [self confirmNextStepWith:obj];
    }];
}

-(void)confirmNextStepWith:(id)obj {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic=obj;
        if([[dic objectForKey:@"code"] integerValue] == 2006) {
            HaveCellpneForBindingAuthVC *bindingVC = [[HaveCellpneForBindingAuthVC alloc] init];
            bindingVC.authInfo = _authInfo;
            bindingVC.category = _category;
            bindingVC.phoneStr = _phoneNumTF.text;
            [self.navigationController pushViewController:bindingVC animated:YES];
        }else if([[dic objectForKey:@"code"] integerValue] == 2000){
            NoRegisterAccountVC *noRegisterVC = [[NoRegisterAccountVC alloc] init];
            noRegisterVC.phoneStr = _phoneNumTF.text;
            noRegisterVC.authInfo = _authInfo;
            noRegisterVC.category = _category;
            [self.navigationController pushViewController:noRegisterVC animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
        }
    }
    
}



- (void)phoneNumTFCompleteInput:(UIButton *)sender
{
    [self.phoneNumTF resignFirstResponder];
}

- (void)detectionPhoneNumTFText:(UIButton *)sender
{
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

