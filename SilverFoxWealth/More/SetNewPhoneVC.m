//
//  SetNewPhoneVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SetNewPhoneVC.h"
#import "RoundCornerClickBT.h"
#import "AnewSendBT.h"
#import "UILabel+LabelStyle.h"
#import "FastAnimationAdd.h"
#import "AddCancelButton.h"
#import "AddBankCardCell.h"
#import "SVProgressHUD.h"
#import "PromptLanguage.h"
#import "DataRequest.h"
#import "AuditPassOfJXBankVC.h"
#import "DispatchHelper.h"
#import "SCMeasureDump.h"
#import "SignHelper.h"

@interface SetNewPhoneVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *authCodeTF;//验证码输入框
@property (strong, nonatomic) RoundCornerClickBT *nextStepBT;
@property (strong, nonatomic) AnewSendBT *afreshSendBT;
@property (nonatomic, strong) NSString *authCodeStr;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SetNewPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    // Do any additional setup after loading the view.
}

- (void)UIDecorate
{
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
    self.tableView.showsVerticalScrollIndicator = NO;//去掉竖直方向的滑动条
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor=[UIColor backgroundGrayColor];
    self.tableView.scrollEnabled=NO;
    
    //手机号输入框
    _phoneTF=[[UITextField alloc] init];
    _phoneTF.delegate=self;
    _phoneTF.placeholder=@"请输入您的新手机号";
    _phoneTF.font=[UIFont systemFontOfSize:14];
    _phoneTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    UIView *idCardTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(idCardTFrespond) title:@"下一项"];
    [self.phoneTF setInputAccessoryView:idCardTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionIdCardTFText:) name:UITextFieldTextDidChangeNotification object:self.phoneTF];
    
    //验证码输入框
    _authCodeTF=[[UITextField alloc] init];
    _authCodeTF.delegate = self;
    _authCodeTF.placeholder = @"请输入您收到的验证码";
    _authCodeTF.font = [UIFont systemFontOfSize:14];
    _authCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _authCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    UIView *authCodeTFDis = [AddCancelButton addCompleteBTOnVC:self withSelector:@selector(authCodeTFDisrespond) title:@"完成"];
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

- (void)idCardTFrespond {
    [self.authCodeTF becomeFirstResponder];
}
- (void)authCodeTFDisrespond{
    [self.authCodeTF resignFirstResponder];
}

//手机号输入框 检测
- (void)detectionIdCardTFText:(NSNotification *)note {
    [self detectionUserInpute];
}

//验证码输入框 检测
- (void)detectionAuthCodeTFText:(NSNotification *)note {
    [self detectionUserInpute];
}
- (void)detectionUserInpute {
    
    if (self.phoneTF.text.length >= 11 && self.authCodeTF.text.length >= 6) {
        self.nextStepBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.nextStepBT.userInteractionEnabled=YES;
    }else {
        self.nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
        self.nextStepBT.userInteractionEnabled=NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor=[UIColor backgroundGrayColor];
        return cell;
    }
    
    if (indexPath.row==1) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"新手机号" inputTF:_phoneTF leftViewWidth:70];
        return cell;
    }
    if (indexPath.row==2) {
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
    
    if (indexPath.row==3) {
        UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor=[UIColor backgroundGrayColor];
        [cell addSubview:_nextStepBT];
        [_nextStepBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(40);
            make.height.equalTo(@45);
            make.left.equalTo(cell.mas_left).offset(43);
            make.right.equalTo(cell.mas_right).offset(-43);
        }];
        return cell;
    }
    return nil;
}

- (void)checkSendAuthCodeBT:(AnewSendBT *)sender
{
    NSLog(@"获取验证码");
    
    if (sender.tag==1) {
        //重发验证码
        [self achieveSign];
    }
    
    if (sender.tag==2){
        //提交验证码
        [self commitCheckingCode];
    }
}

- (void)achieveSign {
    if (self.phoneTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:[PromptLanguage pleaseInputeWith:@"新手机号"]];
        [SVProgressHUD showErrorWithStatus:@"请输入您的新手机号!"];
        return;
    }
    [DispatchHelper afreshSendShortMessageWith:_afreshSendBT];
    
    [[DataRequest sharedClient]requestJXBankSmsCodeWithCellphone:self.phoneTF.text serviceCode:@"mobileModifyPlus" channel:@"000001" callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            _authCodeStr = obj[@"authCode"];
        }else if([obj isKindOfClass:[NSString class]]){
            [SVProgressHUD showErrorWithStatus:obj];
        }
    }];
}


//提交验证码
-(void)commitCheckingCode {
    
    if (self.phoneTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:[PromptLanguage  pleaseInputeWith:@"新手机号"]];
        return;
    }
    
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]exchangeNewPhoneNumberForCensorCodeWithCellphone:self.phoneTF.text smsCode:self.authCodeTF.text authCode:_authCodeStr channel:@"000001" accountId:user.accountId callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                [self afreshSetTradePassword];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (void)afreshSetTradePassword
{
    AuditPassOfJXBankVC *newPhone = [[AuditPassOfJXBankVC alloc] init];
    [self.navigationController pushViewController:newPhone animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return 20;
            break;
        case 3:
            return 150;
            break;
            
        default:
            break;
    }
    return 60;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField==self.phoneTF) {
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

