//
//  BindingBankCardVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BindingBankCardVC.h"
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
#import "PromptLanguage.h"
#import "SignHelper.h"
#import "UMMobClick/MobClick.h"

@interface BindingBankCardVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *idcardTF;
@property (nonatomic, strong) UITextField *cardNOTF;
@property (nonatomic, strong) UITextField *cellphoneTF;
@property (nonatomic, strong) RoundCornerClickBT  *drawalsBT;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AnewSendBT *afreshSendBT;
@property (nonatomic, strong) UITextField *smsAuthNumTF;
@property (nonatomic, strong) NSString *authCodeStr;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation BindingBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
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
    if (indexPath.row == 5) {
        return 150;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"姓名" inputTF:_nameTF leftViewWidth:90];
        _nameTF.textColor = [UIColor depictBorderGrayColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"身份证" inputTF:_idcardTF leftViewWidth:90];
        _idcardTF.textColor = [UIColor depictBorderGrayColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 2) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"银行卡号" inputTF:_cardNOTF leftViewWidth:90];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 3) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"手机号" inputTF:_cellphoneTF leftViewWidth:90];
        _cellphoneTF.textColor = [UIColor depictBorderGrayColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row == 4) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"短信验证码" inputTF:_smsAuthNumTF leftViewWidth:90];
        //添加获取验证码按钮
        _afreshSendBT = [AnewSendBT buttonWithType:UIButtonTypeCustom];
        _afreshSendBT.frame = CGRectMake(-10, 0, 80, 30);
        _afreshSendBT.layer.cornerRadius = 5;
        [_afreshSendBT setTitle:@"获取短信" forState:UIControlStateNormal];
        _afreshSendBT.layer.masksToBounds = YES;
        [_afreshSendBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
        [_afreshSendBT addTarget:self action:@selector(checkSendAuthCodeBT:) forControlEvents:UIControlEventTouchUpInside];
        _afreshSendBT.titleLabel.font=[UIFont systemFontOfSize:14];
        _afreshSendBT.titleLabel.textAlignment=NSTextAlignmentCenter;
        [_smsAuthNumTF setRightView:_afreshSendBT];
        _smsAuthNumTF.rightViewMode=UITextFieldViewModeAlways;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 5) {
        UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor=[UIColor backgroundGrayColor];
        [cell addSubview:_drawalsBT];
        [_drawalsBT mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor backgroundGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 120, 20)];
    label.text = @"持卡人信息";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor characterBlackColor];
    label.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:label];
    return headView;
}

- (void)checkSendAuthCodeBT:(AnewSendBT *)sender
{
    [MobClick event:@"band_card_page_click_get_sms"];
    // 倒计时开始
    [DispatchHelper afreshSendShortMessageWith:_afreshSendBT];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] requestJXBankSmsCodeWithCellphone:user.cellphone serviceCode:@"cardBindPlus" channel:@"000001" callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            _authCodeStr = obj[@"authCode"];
        }
    }];
}



- (void)UIDecorate {
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"绑定银行卡";
    self.title = @"绑定银行卡";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf accessFirstVC];
    };
    
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor=[UIColor backgroundGrayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.tableView.scrollEnabled=NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _nameTF = [[UITextField alloc] init];
    _nameTF.delegate=self;
    _nameTF.font=[UIFont systemFontOfSize:14];
    _nameTF.enabled = NO;
    if (user.name.length > 0) {
        _nameTF.text = [StringHelper coverUserNameWith:user.name];
    }
    
    _idcardTF = [[UITextField alloc] init];
    _idcardTF.delegate = self;
    _idcardTF.font = [UIFont systemFontOfSize:14];
    _idcardTF.enabled = NO;
    if (user.idcard.length > 0) {
        _idcardTF.text = [user.idcard stringByReplacingCharactersInRange:NSMakeRange(4, user.idcard.length-8) withString:@"***********"];
    }
    UIView *authCardNOTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(drawalsMoneyTFDisrespond) title:@"下一项"];
    
    _cellphoneTF = [[UITextField alloc] init];
    _cellphoneTF.delegate=self;
    _cellphoneTF.font=[UIFont systemFontOfSize:14];
    _cellphoneTF.enabled = NO;
    if (user.name.length > 0) {
        _cellphoneTF.text = user.cellphone;
    }
    
    _cardNOTF = [[UITextField alloc] init];
    _cardNOTF.delegate = self;
    _cardNOTF.placeholder = @"请输入银行卡号";
    _cardNOTF.font = [UIFont systemFontOfSize:14];
    _cardNOTF.keyboardType = UIKeyboardTypeNumberPad;
    _cardNOTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_cardNOTF setInputAccessoryView:authCardNOTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionDrawalsMoneyTFText:) name:UITextFieldTextDidChangeNotification object:_cardNOTF];
    
    //验证码输入框
    _smsAuthNumTF = [[UITextField alloc] init];
    _smsAuthNumTF.delegate = self;
    _smsAuthNumTF.placeholder = @"请输入短信验证码";
    _smsAuthNumTF.font = [UIFont systemFontOfSize:14];
    _smsAuthNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _smsAuthNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *authCodeTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(smsAuthTFDisrespond) title:@"完成"];
    [_smsAuthNumTF setInputAccessoryView:authCodeTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionAuthCodeTFText:) name:UITextFieldTextDidChangeNotification object:_smsAuthNumTF];
    
    _drawalsBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_drawalsBT setTitle:@"确定" forState:UIControlStateNormal];
    
    _drawalsBT.titleLabel.font = [UIFont systemFontOfSize:16];
    _drawalsBT.backgroundColor = [UIColor typefaceGrayColor];
    _drawalsBT.userInteractionEnabled = NO;
    [FastAnimationAdd codeBindAnimation:_drawalsBT];
    [_drawalsBT addTarget:self action:@selector(checkSureBT:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView reloadData];
}

- (void)checkSureBT:(RoundCornerClickBT *)sender
{
    [MobClick event:@"band_card_page_click_band_card"];
    _drawalsBT.userInteractionEnabled = NO;
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]bindingBankCardWithCustomerId:user.customerId cardNo:_cardNOTF.text smsCode:_smsAuthNumTF.text channel:@"000001" authCode:_authCodeStr callback:^(id obj) {
        DLog(@"绑卡=====%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] integerValue] == 2000) {
                if ([_rechargeType isEqualToString:@"rechage"] || [_rechargeType isEqualToString:@"drawals"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }else{
                _drawalsBT.userInteractionEnabled = YES;
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (void)detectionUserInpute {
    
    if (self.cardNOTF.text.length > 15 && self.smsAuthNumTF.text.length == 6) {
        self.drawalsBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.drawalsBT.userInteractionEnabled=YES;
    }else {
        self.drawalsBT.backgroundColor=[UIColor typefaceGrayColor];
        self.drawalsBT.userInteractionEnabled=NO;
    }
}

- (void)detectionDrawalsMoneyTFText:(NSNotification *)note
{
    [self detectionUserInpute];
}

- (void)detectionAuthCodeTFText:(NSNotification *)note {
    [self detectionUserInpute];
}


- (void)drawalsMoneyTFDisrespond
{
    [self.smsAuthNumTF becomeFirstResponder];
}
- (void)smsAuthTFDisrespond
{
    [self.smsAuthNumTF resignFirstResponder];
}


- (void)accessFirstVC
{
    if ([_rechargeType isEqualToString:@"rechage"] || [_rechargeType isEqualToString:@"drawals"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma -mark textFiledDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self detectionUserInpute];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.cardNOTF) {
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

