

#import "EntryIdentityCardVC.h"
#import "RegisterPageVC.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import "Validation.h"
#import "AddCancelButton.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "UILabel+LabelStyle.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "SignHelper.h"
#import "SCMeasureDump.h"

@interface EntryIdentityCardVC ()
@property (strong, nonatomic) UITextField *identityCardTF;
@property (strong, nonatomic) RoundCornerClickBT *nextStepBT;

@end

@implementation EntryIdentityCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    self.nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionIdentityCardTFText:) name:UITextFieldTextDidChangeNotification object:nil];
    [self.identityCardTF becomeFirstResponder];
}

- (void)detectionIdentityCardTFText:(NSNotification *)note {
    
    if (self.identityCardTF.text.length != 0) {
        self.identityCardTF.rightView.hidden=NO;
    }else{
        self.identityCardTF.rightView.hidden=YES;
    }
    [self detectionIdentityCardTF];
}


//验证身份证格式 去服务器检查
- (void)nextStep:(UIButton *)sender {
    
    if (self.identityCardTF.text.length==0){
        //提示错误
        [SVProgressHUD showErrorWithStatus:[PromptLanguage  pleaseInputeWith:@"身份证号码"]];
        return;
    }
    
    if (![Validation  validateIdentityCard:self.identityCardTF.text]){
        //提示错误
        [SVProgressHUD showErrorWithStatus:LoginForIdCardFormatError];
        return;
    }
    [self achieveSign];
}


#pragma mark-----短信签名*
- (void)achieveSign {
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

//重置登录密码 之 发送短信
-(void)resetPasswordAchieveCheckingCode:(NSString *)sig {
    
    NSString *idcard = self.identityCardTF.text;
    NSString *sign_type = @"MD5";
    NSString *cellphone = self.phoneNumStr;
    NSString *type = @"resetloginpassword";
    
    NSDictionary *signDic=NSDictionaryOfVariableBindings(type,cellphone,idcard,sign_type);
    NSString *sign = [SignHelper  partnerSignOrder:signDic sig:sig];
    
    [[DataRequest sharedClient] retrieveLoginPasswordForSendNoteWithCellphone:self.phoneNumStr idcard:self.identityCardTF.text sign:sign callback:^(id obj) {
        DLog(@"重置密码 发送短信结果2==%@",obj);
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=obj;
            if ([dic[@"code"] intValue] == 2000) {
                [self nextPage];
            }else{
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            }
        }
    }];
}

//发送短信后 进入 重置密码页面
- (void)nextPage {
    RegisterPageVC *re=[[RegisterPageVC alloc] init];
    re.cellPhoneStr=[self.phoneNumStr copy];
    re.workStatus=RetrievePasswordState; //重置密码模式
    [self.navigationController pushViewController:re animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self detectionIdentityCardTF];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"Xx1234567890"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    BOOL canChange = [string isEqualToString:filtered];
    return range.location > 17 ? NO : canChange;
    
    return YES;
}

- (void)detectionIdentityCardTF {
    if ([Validation  validateIdentityCard:self.identityCardTF.text]) {
        self.nextStepBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.nextStepBT.userInteractionEnabled=YES;
    }else{
        self.nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
        self.nextStepBT.userInteractionEnabled=NO;
    }
}

//界面布置
- (void)UIDecorate {
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"输入身份证";
    self.title = @"输入身份证";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    _identityCardTF=[[UITextField alloc] init];
    [self.view addSubview:_identityCardTF];
    _identityCardTF.delegate=self;
    _identityCardTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _identityCardTF.font=[UIFont systemFontOfSize:14];
    _identityCardTF.placeholder=@"请输入您的身份证号";
    _identityCardTF.returnKeyType=UIReturnKeyDone;
    _identityCardTF.backgroundColor=[UIColor whiteColor];
    [_identityCardTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customNav.mas_bottom).offset(20);
        make.height.equalTo(@60);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIView *phoneLB = [AddCancelButton addTextFieldLeftViewWithTitle:@"身份证" width:70];
    [_identityCardTF setLeftView:phoneLB];
    _identityCardTF.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *noteLB = [[UILabel alloc] init];
    [self.view addSubview:noteLB];
    noteLB.text = @"您为交易用户，为了保证您的资金安全，请输入您交易时的身份证号码";
    noteLB.numberOfLines = 0;
    [noteLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
    noteLB.textAlignment=NSTextAlignmentCenter;
    [noteLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_identityCardTF.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    
    _nextStepBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_nextStepBT];
    [_nextStepBT setTitle:@"下一步" forState:UIControlStateNormal];
    _nextStepBT.titleLabel.font = [UIFont systemFontOfSize:16];
    [FastAnimationAdd codeBindAnimation:_nextStepBT];
    _nextStepBT.backgroundColor = [UIColor typefaceGrayColor];
    _nextStepBT.userInteractionEnabled = NO;
    [_nextStepBT addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [_nextStepBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noteLB.mas_bottom).offset(20);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    
    
}



@end

