//
//  OriginallyPhoneVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/3/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OriginallyPhoneVC.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import "Validation.h"
#import "AddCancelButton.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "AddBankCardCell.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "DispatchHelper.h"
#import "AnewSendBT.h"
#import "SetNewPhoneVC.h"
#import "SCMeasureDump.h"
#import "SignHelper.h"


@interface OriginallyPhoneVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITextField *nameTF;
@property (strong, nonatomic) UITextField *idCardTF;
@property (nonatomic, strong) UITextField *authCodeTF;//验证码输入框
@property (strong, nonatomic) RoundCornerClickBT *nextStepBT;
@property (strong, nonatomic) AnewSendBT *afreshSendBT;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation OriginallyPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    // Do any additional setup after loading the view.
}
- (void)UIDecorate {
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"更换手机号";
    self.title = @"更换手机号";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.tableView = [[UITableView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;//去掉竖直方向的滑动条
    
    self.view.backgroundColor=[UIColor backgroundGrayColor];
    self.tableView.scrollEnabled=NO;
    
    //姓名输入框
    _nameTF=[[UITextField alloc] init];
    _nameTF.delegate=self;
    _nameTF.font=[UIFont systemFontOfSize:14];
    _nameTF.placeholder=@"请输入您的身份证号";
    _nameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    UIView *nameTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(nameTFrespond) title:@"下一项"];
    [self.nameTF setInputAccessoryView:nameTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionNameTFText:) name:UITextFieldTextDidChangeNotification object:self.nameTF];
    
    //手机号输入框
    _idCardTF=[[UITextField alloc] init];
    _idCardTF.delegate=self;
    _idCardTF.placeholder=@"请输入原来使用的手机号";
    _idCardTF.font=[UIFont systemFontOfSize:14];
    _idCardTF.keyboardType=UIKeyboardTypeNumberPad;
    _idCardTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    UIView *idCardTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(idCardTFrespond) title:@"下一项"];
    [self.idCardTF setInputAccessoryView:idCardTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionIdCardTFText:) name:UITextFieldTextDidChangeNotification object:self.idCardTF];
    
    //验证码输入框
    _authCodeTF=[[UITextField alloc] init];
    _authCodeTF.delegate=self;
    _authCodeTF.placeholder=@"请输入您收到的验证码";
    _authCodeTF.font=[UIFont systemFontOfSize:14];
    _authCodeTF.keyboardType=UIKeyboardTypeNumberPad;
    _authCodeTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    UIView *authCodeTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(authCodeTFDisrespond) title:@"完成"];
    [self.authCodeTF setInputAccessoryView:authCodeTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionAuthCodeTFText:) name:UITextFieldTextDidChangeNotification object:self.authCodeTF];
    
    _nextStepBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_nextStepBT setTitle:@"下一步" forState:UIControlStateNormal];
    _nextStepBT.tag = 2;
    _nextStepBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
    _nextStepBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_nextStepBT];
    [_nextStepBT addTarget:self action:@selector(checkSendAuthCodeBT:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView reloadData];
}

#pragma mark-----更换手机号短信签名*
- (void)achieveSign {
    [[DataRequest sharedClient]requestSendSMSMD5KEYWithCallback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                NSDictionary *dict = obj[@"data"];
                NSString *resultStr = dict[@"key"];
                [self sendShortMassage:resultStr];
            }
        }
    }];
}


- (void)sendShortMassage:(NSString *)sig {
    
    if (self.nameTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:[PromptLanguage pleaseInputeWith:@"身份证"]];
        [SVProgressHUD showErrorWithStatus:@"请输入您的身份证号!"];
        return;
    }
    if (self.idCardTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:[PromptLanguage pleaseInputeWith:@"原手机号"]];
        [SVProgressHUD showErrorWithStatus:@"请输入您的原手机号!"];
        return;
    }
    
    if (![Validation validateIdentityCard:self.nameTF.text]) {
        [SVProgressHUD showErrorWithStatus:LoginForIdCardFormatError];
        return;
    }
    
    if (![Validation mobileNum:self.idCardTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"土豪,手机号格式有误!"];
        return;
    }
    
    // 倒计时开始
    [DispatchHelper afreshSendShortMessageWith:_afreshSendBT];
    NSString *sign_type=@"MD5";
    NSString *cellphone = self.idCardTF.text;
    NSString *type = @"changecellphoneold";
    NSDictionary *signDic=NSDictionaryOfVariableBindings(cellphone,type,sign_type);
    NSString *sign=[SignHelper  partnerSignOrder:signDic sig:sig];
    
    [[DataRequest sharedClient] afreshAchieveVerificationCodeWithCellphone:cellphone smsType:type sign:sign callback:^(id obj) {
        DLog(@"更改手机号 并发送短信====%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=obj;
            if ([dic[@"code"] intValue] == 2000) {
                
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor=[UIColor backgroundGrayColor];
        UILabel *titleLB = [[UILabel alloc] init];
        [cell addSubview:titleLB];
        titleLB.text = @"为保证您的资产安全,在更换手机号前需验证您的身份信息";
        titleLB.textColor = [UIColor characterBlackColor];
        titleLB.numberOfLines = 0;
        titleLB.textAlignment = NSTextAlignmentCenter;
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.top.equalTo(@20);
        }];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row==1) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"身份证" inputTF:_nameTF leftViewWidth:70];
        return cell;
    }
    
    if (indexPath.row==2) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"原手机号" inputTF:_idCardTF leftViewWidth:70];
        return cell;
    }
    if (indexPath.row==3) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"验证码" inputTF:_authCodeTF leftViewWidth:70];
        
        //添加获取验证码按钮
        _afreshSendBT=[AnewSendBT buttonWithType:UIButtonTypeCustom];
        _afreshSendBT.frame=CGRectMake(-10, 0, 80, 30);
        _afreshSendBT.layer.cornerRadius = 5;
        [_afreshSendBT setTitle:@"获取短信" forState:UIControlStateNormal];
        _afreshSendBT.layer.masksToBounds = YES;
        _afreshSendBT.tag=1;
        //_afreshSendBT.backgroundColor = [UIColor iconBlueColor];
        [_afreshSendBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
        [_afreshSendBT addTarget:self action:@selector(checkSendAuthCodeBT:) forControlEvents:UIControlEventTouchUpInside];
        _afreshSendBT.titleLabel.font=[UIFont systemFontOfSize:14];
        _afreshSendBT.titleLabel.textAlignment=NSTextAlignmentCenter;
        [_authCodeTF setRightView:_afreshSendBT];
        _authCodeTF.rightViewMode=UITextFieldViewModeAlways;
        return cell;
    }
    
    if (indexPath.row==4) {
        UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor=[UIColor backgroundGrayColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [cell addSubview:_nextStepBT];
        [_nextStepBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(40);
            make.height.equalTo(@45);
            make.left.equalTo(cell.mas_left).offset(43);
            make.right.equalTo(cell.mas_right).offset(-43);
        }];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)checkSendAuthCodeBT:(AnewSendBT *)sender
{
    DLog(@"获取验证码");
    if (sender.tag==1) {
        //重发验证码
        [self achieveSign];
    }
    
    if (sender.tag==2){
        //提交验证码
        [self commitCheckingCode];
    }
}

//提交验证码
-(void)commitCheckingCode {
    [[DataRequest sharedClient]exchangePhoneNumberForCensorCodeWithCellphone:self.idCardTF.text idCard:self.nameTF.text smsCode:self.authCodeTF.text smsType:@"changecellphoneold" callback:^(id obj) {
        DLog(@"验证旧手机号结果======%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                [self afreshSetTradePassword];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}
//跳转到下一页
- (void)afreshSetTradePassword
{
    SetNewPhoneVC *newPhone = [[SetNewPhoneVC alloc] init];
    [self.navigationController pushViewController:newPhone animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return 80;
            break;
        case 4:
            return 150;
            break;
            
        default:
            break;
    }
    return 60;
}

- (void)detectionUserInpute {
    
    if (self.nameTF.text.length >= 18 && self.idCardTF.text.length >= 11 && self.authCodeTF.text.length >= 6) {
        self.nextStepBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.nextStepBT.userInteractionEnabled=YES;
    }else {
        self.nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
        self.nextStepBT.userInteractionEnabled=NO;
    }
}

//姓名输入框 检测
- (void)detectionNameTFText:(NSNotification *)note {
    [self detectionUserInpute];
}

//身份证号输入框 检测
- (void)detectionIdCardTFText:(NSNotification *)note {
    [self detectionUserInpute];
}

//验证码输入框 检测
- (void)detectionAuthCodeTFText:(NSNotification *)note {
    [self detectionUserInpute];
}
- (void)nameTFrespond {
    [self.idCardTF becomeFirstResponder];
}

- (void)idCardTFrespond {
    [self.authCodeTF becomeFirstResponder];
}
- (void)authCodeTFDisrespond{
    [self.authCodeTF resignFirstResponder];
}





#pragma -mark textFiledDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self detectionUserInpute];
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField==self.nameTF) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"Xx1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        return range.location > 17 ? NO : canChange;
    }
    
    if (textField==self.idCardTF) {
        if (range.location>10) {
            return NO;
        }
    }
    
    if (textField==self.authCodeTF) {
        if (range.location >5) {
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

