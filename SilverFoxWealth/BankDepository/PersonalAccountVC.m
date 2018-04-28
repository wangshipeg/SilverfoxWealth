//
//  PersonalAccountVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PersonalAccountVC.h"
#import "AddCancelButton.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "Validation.h"
#import "AddBankCardCell.h"
#import "AnewSendBT.h"
#import "DispatchHelper.h"
#import "DataRequest.h"
#import "StringHelper.h"
#import "SVProgressHUD.h"
#import "UILabel+LabelStyle.h"
#import "VCAppearManager.h"
#import "SCMeasureDump.h"
#import "WithoutAuthorization.h"
#import "UserInfoUpdate.h"
#import "UMMobClick/MobClick.h"

@interface PersonalAccountVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *idcardTF;
@property (nonatomic, strong) UITextField *cardNOTF;
@property (nonatomic, strong) UITextField *phoneNOTF;
@property (nonatomic, strong) UITextField *smsAuthNumTF;
@property (nonatomic, strong) RoundCornerClickBT  *drawalsBT;
@property (nonatomic, strong) AnewSendBT *afreshSendBT;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *isAgreeBT;
@property (nonatomic, strong) UIButton *personalBT;

@property (nonatomic, strong) NSString *authCodeStr;
@property (nonatomic, strong) NSString *accountIdStr;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation PersonalAccountVC
{
    BOOL isAgree;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    isAgree = YES;
    
    
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            return 200;
        }
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"姓名" inputTF:_nameTF leftViewWidth:90];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 1) {
            AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"身份证" inputTF:_idcardTF leftViewWidth:90];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"银行卡号" inputTF:_cardNOTF leftViewWidth:90];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 1) {
            AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"预留手机号" inputTF:_phoneNOTF leftViewWidth:90];
            _phoneNOTF.textColor = [UIColor depictBorderGrayColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 2) {
            AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"短信验证码" inputTF:_smsAuthNumTF leftViewWidth:90];
            //添加获取验证码按钮
            _afreshSendBT = [AnewSendBT buttonWithType:UIButtonTypeCustom];
            _afreshSendBT.frame = CGRectMake(-10, 0, 80, 30);
            [_afreshSendBT setTitle:@"获取短信" forState:UIControlStateNormal];
            [_afreshSendBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
            [_afreshSendBT addTarget:self action:@selector(checkSendAuthCodeBT:) forControlEvents:UIControlEventTouchUpInside];
            _afreshSendBT.titleLabel.font=[UIFont systemFontOfSize:14];
            _afreshSendBT.titleLabel.textAlignment=NSTextAlignmentCenter;
            [_smsAuthNumTF setRightView:_afreshSendBT];
            _smsAuthNumTF.rightViewMode=UITextFieldViewModeAlways;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if (indexPath.row == 3) {
            UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.backgroundColor=[UIColor backgroundGrayColor];
            [cell addSubview:_bottomView];
            [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(10);
                make.height.equalTo(@20);
                make.left.equalTo(cell.mas_left).offset(15);
                make.right.equalTo(cell.mas_right);
            }];
            [cell addSubview:_drawalsBT];
            
            [_drawalsBT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(65);
                make.height.equalTo(@45);
                make.left.equalTo(cell.mas_left).offset(43);
                make.right.equalTo(cell.mas_right).offset(-43);
            }];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor backgroundGrayColor];
    UILabel *label = [[UILabel alloc] init];
    [label decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
    [headView addSubview:label];
    if (section == 0) {
        label.text = @"持卡人信息";
    }
    if (section == 1) {
        label.text = @"开户验证";
    }
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(20);
        make.height.equalTo(@25);
        make.left.equalTo(headView.mas_left).offset(15);
    }];
    return headView;
}

- (void)checkSendAuthCodeBT:(AnewSendBT *)sender
{
    [MobClick event:@"open_account_click_send_sms"];
    [DispatchHelper afreshSendShortMessageWith:_afreshSendBT];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] requestJXBankSmsCodeWithCellphone:user.cellphone serviceCode:@"accountOpenPlus" channel:@"000001" callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            _authCodeStr = obj[@"authCode"];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            [SVProgressHUD showErrorWithStatus:obj];
        }
    }];
}

- (void)UIDecorate {
    self.navigationController.navigationBar.hidden = YES;
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else  {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"江西银行存管开户";
    self.title = @"江西银行存管开户";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    weakSelf.customNav.leftViewController = ^{
        [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor=[UIColor backgroundGrayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.tableView.bounces = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    _nameTF = [[UITextField alloc] init];
    _idcardTF = [[UITextField alloc] init];
    if (user.name.length > 0) {
        _nameTF.enabled = NO;
        _idcardTF.enabled = NO;
        _nameTF.text = user.name;
        _idcardTF.text = user.idcard;
    } else {
        _nameTF.delegate = self;
        _nameTF.placeholder = @"请输入您的真实姓名";
        UIView *nameTFDis = [AddCancelButton addCompleteBTOnVC:self withSelector:@selector(nameTFDisrespond) title:@"下一项"];
        [_nameTF setInputAccessoryView:nameTFDis];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionTFText:) name:UITextFieldTextDidChangeNotification object:_nameTF];
        
        _idcardTF.delegate = self;
        _idcardTF.placeholder = @"请输入您的身份证号";
        _idcardTF.keyboardType = UIKeyboardTypeASCIICapable;
        _idcardTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *idcardTFTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(idcardTFDisrespond) title:@"下一项"];
        [_idcardTF setInputAccessoryView:idcardTFTFDis];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionTFText:) name:UITextFieldTextDidChangeNotification object:_idcardTF];
    }
    
    _cardNOTF = [[UITextField alloc] init];
    _cardNOTF.delegate = self;
    _cardNOTF.placeholder = @"请输入您的银行卡号";
    _cardNOTF.keyboardType = UIKeyboardTypeNumberPad;
    _cardNOTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *cardNOTFDis = [AddCancelButton addCompleteBTOnVC:self withSelector:@selector(cardNOTFDisrespond) title:@"完成"];
    [_cardNOTF setInputAccessoryView:cardNOTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionTFText:) name:UITextFieldTextDidChangeNotification object:_cardNOTF];
    
    _phoneNOTF = [[UITextField alloc] init];
    _phoneNOTF.enabled = NO;
    _phoneNOTF.text = user.cellphone;
    
    _smsAuthNumTF = [[UITextField alloc] init];
    _smsAuthNumTF.delegate = self;
    _smsAuthNumTF.placeholder = @"请输入短信验证码";
    _smsAuthNumTF.font = [UIFont systemFontOfSize:14];
    _smsAuthNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _smsAuthNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *authCodeTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(smsAuthTFDisrespond) title:@"完成"];
    [_smsAuthNumTF setInputAccessoryView:authCodeTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionTFText:) name:UITextFieldTextDidChangeNotification object:_smsAuthNumTF];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor backgroundGrayColor];
    
    _isAgreeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomView addSubview:_isAgreeBT];
    [_isAgreeBT setImage:[UIImage imageNamed:@"AgreeBT"] forState:UIControlStateNormal];
    [_isAgreeBT setImage:[UIImage imageNamed:@"DisagreeBT"] forState:UIControlStateSelected];
    [_isAgreeBT addTarget:self action:@selector(agreeImage:) forControlEvents:UIControlEventTouchUpInside];
    [_isAgreeBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(self.bottomView.mas_left).offset(3);
        make.height.equalTo(@15);
        make.width.equalTo(@15);
    }];
    
    UILabel *agreeLabel = [[UILabel alloc] init];
    [self.bottomView addSubview:agreeLabel];
    agreeLabel.text = @"我同意";
    [agreeLabel decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor characterBlackColor]];
    [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(self.isAgreeBT.mas_right).offset(3);
        make.height.equalTo(@15);
    }];
    
    _personalBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomView addSubview:_personalBT];
    [_personalBT setTitle:@"《江西银行存管开户协议》" forState:UIControlStateNormal];
    [_personalBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    _personalBT.titleLabel.font = [UIFont systemFontOfSize:13];
    [_personalBT addTarget:self action:@selector(clickPersonalBT:) forControlEvents:UIControlEventTouchUpInside];
    [_personalBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(agreeLabel.mas_right);
        make.height.equalTo(@15);
    }];
    
    UIButton *userPersonalBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomView addSubview:userPersonalBT];
    [userPersonalBT setTitle:@"《用户授权协议》" forState:UIControlStateNormal];
    [userPersonalBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    userPersonalBT.titleLabel.font = [UIFont systemFontOfSize:13];
    [userPersonalBT addTarget:self action:@selector(clickUserPersonalBT:) forControlEvents:UIControlEventTouchUpInside];
    [userPersonalBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(self.personalBT.mas_right);
        make.height.equalTo(@15);
    }];
    
    _drawalsBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_drawalsBT setTitle:@"开户" forState:UIControlStateNormal];
    _drawalsBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _drawalsBT.backgroundColor=[UIColor typefaceGrayColor];
    _drawalsBT.userInteractionEnabled = NO;
    [FastAnimationAdd codeBindAnimation:_drawalsBT];
    [_drawalsBT addTarget:self action:@selector(checkSureBT:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view bringSubviewToFront:_customNav];
}

- (void)clickPersonalBT:(UIButton *)sender
{
    [MobClick event:@"open_account_click_agreement"];
    [VCAppearManager pushH5VCWithCurrentVC:self workS:userPersonal];
}


- (void)clickUserPersonalBT:(UIButton *)sender
{
    [MobClick event:@"open_account_click_agreement"];
    [VCAppearManager pushH5VCWithCurrentVC:self workS:openAccount];
}

//点击同意图片响应事件
- (void)agreeImage:(UIButton *)sender{
    if (sender.selected) {
        isAgree = YES;
    }else {
        isAgree = NO;
    }
    [self detectionUserInpute];
    sender.selected = !sender.selected;
}
- (void)checkSureBT:(RoundCornerClickBT *)sender
{
    _drawalsBT.userInteractionEnabled = NO;
    [MobClick event:@"open_account_click_open_account_btn"];
    [[DataRequest sharedClient]requestOpenAmountOfJXWithCellphone:_phoneNOTF.text idcard:_idcardTF.text channel:@"000001" name:_nameTF.text cardNO:_cardNOTF.text authCode:_authCodeStr smsCode:_smsAuthNumTF.text callback:^(id obj) {
        DLog(@"开通银行存管账户======%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            //成功
            if ([obj[@"code"] intValue] == 2000) {
                [SCMeasureDump shareSCMeasureDump].openAccountPresentVC = @"openAccountVC";
                [UserInfoUpdate updateUserInfoWithTargerVC:self];
                [VCAppearManager presentSetUpTradePasswordVC:self];
            } else {
                _drawalsBT.userInteractionEnabled = YES;
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (void)detectionUserInpute {
    
    if (self.nameTF.text.length > 0 && self.smsAuthNumTF.text.length == 6 && _idcardTF.text.length > 10 && _cardNOTF.text.length > 15 && isAgree) {
        self.drawalsBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.drawalsBT.userInteractionEnabled=YES;
    }else {
        self.drawalsBT.backgroundColor=[UIColor typefaceGrayColor];
        self.drawalsBT.userInteractionEnabled=NO;
    }
}

- (void)detectionTFText:(NSNotification *)note {
    [self detectionUserInpute];
}

- (void)nameTFDisrespond
{
    [self.idcardTF becomeFirstResponder];
}

- (void)idcardTFDisrespond
{
    [self.cardNOTF becomeFirstResponder];
}
- (void)cardNOTFDisrespond
{
    [self.cardNOTF resignFirstResponder];
}
- (void)smsAuthTFDisrespond
{
    [self.smsAuthNumTF resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.idcardTF resignFirstResponder];
    [self.cardNOTF resignFirstResponder];
    [self.smsAuthNumTF resignFirstResponder];
}

#pragma -mark textFiledDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self detectionUserInpute];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.idcardTF) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"Xx1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        return range.location > 17 ? NO : canChange;
    }
    if (textField==self.cardNOTF) {
        if (range.location > 18) {
            return NO;
        }
    }
    if (textField==self.smsAuthNumTF) {
        if (range.location > 5) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==self.smsAuthNumTF) {
        CGFloat rects = self.view.frame.size.height - 64 - (360 + textField.bounds.size.height + 216 +50);
        if (rects <= 0) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.view.frame;
                frame.origin.y = rects;
                self.tableView.frame = frame;
            }];
        }
        return YES;
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        
        if (IS_iPhoneX) {
            frame.origin.y = iPhoneX_Navigition_Bar_Height;
        }else{
            frame.origin.y = 64;
        }
        self.tableView.frame = frame;
    }];
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

