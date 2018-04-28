//
//  QuickPaymentVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "QuickPaymentVC.h"
#import "AddCancelButton.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "Validation.h"
#import "AddBankCardCell.h"
#import "AnewSendBT.h"
#import "DispatchHelper.h"
#import "DataRequest.h"
#import "IndividualInfoManage.h"
#import "StringHelper.h"
#import "SVProgressHUD.h"
#import "RechargeAndDrawalsSuccessVC.h"
#import "RechargeVC.h"
#import "BindingBankCardVC.h"
#import "UMMobClick/MobClick.h"
#import "PromptLanguage.h"

@interface QuickPaymentVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITextField *bindingBankInfoTF;
@property (nonatomic, strong) UITextField *drawalsMoneyTF;
@property (nonatomic, strong) UITextField *phoneNumTF;
@property (nonatomic, strong) UITextField *smsAuthNumTF;
@property (nonatomic, strong) RoundCornerClickBT  *drawalsBT;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AnewSendBT *afreshSendBT;
@property (nonatomic, strong) NSString *authCodeStr;
@property (nonatomic, strong) UILabel *bankInfoLB;

@end

@implementation QuickPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    [self addNewMessageObserve];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

- (void)addNewMessageObserve
{
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(addMessageNoteWith) name:@"rechargeShow" object:nil];
}

- (void)addMessageNoteWith
{
    self.tableView.userInteractionEnabled = YES;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 150;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AddBankCardCell *cell = [[AddBankCardCell alloc] initWithTitle:@"已绑银行卡" inputTF:_bindingBankInfoTF leftViewWidth:90];
        [cell addSubview:_bankInfoLB];
        if (_bankLimit) {
            _bankInfoLB.attributedText = _bankLimit;
        }else{
            _bankInfoLB.text = @"绑定银行卡";
            _bankInfoLB.textColor = [UIColor iconBlueColor];
        }
        
        [_bankInfoLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(105);
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right);
            make.height.equalTo(@50);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row == 1) {
        AddBankCardCell *cell = [[AddBankCardCell alloc] initWithTitle:@"充值金额" inputTF:_drawalsMoneyTF leftViewWidth:90];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row == 2) {
        AddBankCardCell *cell = [[AddBankCardCell alloc] initWithTitle:@"预留手机号" inputTF:_phoneNumTF leftViewWidth:90];
        _phoneNumTF.textColor = [UIColor depictBorderGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 3) {
        AddBankCardCell *cell = [[AddBankCardCell alloc] initWithTitle:@"短信验证码" inputTF:_smsAuthNumTF leftViewWidth:90];
        _afreshSendBT = [AnewSendBT buttonWithType:UIButtonTypeCustom];
        _afreshSendBT.frame = CGRectMake(-10, 0, 80, 30);
        _afreshSendBT.layer.cornerRadius = 5;
        [_afreshSendBT setTitle:@"获取短信" forState:UIControlStateNormal];
        _afreshSendBT.layer.masksToBounds = YES;
        [_afreshSendBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
        [_afreshSendBT addTarget:self action:@selector(checkSendAuthCodeBT:) forControlEvents:UIControlEventTouchUpInside];
        _afreshSendBT.titleLabel.font = [UIFont systemFontOfSize:14];
        _afreshSendBT.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_smsAuthNumTF setRightView:_afreshSendBT];
        _smsAuthNumTF.rightViewMode = UITextFieldViewModeAlways;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 4) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor backgroundGrayColor];
        [cell addSubview:_drawalsBT];
        [_drawalsBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(40);
            make.height.equalTo(@45);
            make.left.equalTo(cell.mas_left).offset(43);
            make.right.equalTo(cell.mas_right).offset(-43);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor backgroundGrayColor];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (!_bankLimit) {
            [MobClick event:@"recharge_click_go_band_card"];
            BindingBankCardVC *bindVC = [[BindingBankCardVC alloc] init];
            bindVC.rechargeType = @"rechage";
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *VC = (UINavigationController *)control.selectedViewController;
            UIViewController *productVC = [VC topViewController];
            [productVC.navigationController pushViewController:bindVC animated:YES];
        }
    }
}

- (void)checkSendAuthCodeBT:(AnewSendBT *)sender
{
    [MobClick event:@"recharge_click_get_sms"];
    [DispatchHelper afreshSendShortMessageWith:_afreshSendBT];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]requestRechargeSmsCodeWithUserId:user.customerId cellphone:_phoneNumTF.text channel:@"000001" callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            _authCodeStr = obj[@"authCode"];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            [SVProgressHUD showErrorWithStatus:obj];
        }
    }];
}

- (void)UIDecorate {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor=[UIColor backgroundGrayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled=NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.userInteractionEnabled = NO;
    
    _bindingBankInfoTF = [[UITextField alloc] init];
    _bindingBankInfoTF.enabled = NO;
    
    _bankInfoLB = [[UILabel alloc] init];
    _bankInfoLB.textAlignment = NSTextAlignmentLeft;
    _bankInfoLB.numberOfLines = 0;
    _bankInfoLB.font = [UIFont systemFontOfSize:14];
    
    _drawalsMoneyTF = [[UITextField alloc] init];
    _drawalsMoneyTF.delegate = self;
    _drawalsMoneyTF.placeholder = @"最低充值500元";
    _drawalsMoneyTF.font = [UIFont systemFontOfSize:14];
    _drawalsMoneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    _drawalsMoneyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *authCardNOTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(drawalsMoneyTFDisrespond) title:@"下一项"];
    [_drawalsMoneyTF setInputAccessoryView:authCardNOTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionDrawalsMoneyTFText:) name:UITextFieldTextDidChangeNotification object:_drawalsMoneyTF];
    
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    _phoneNumTF = [[UITextField alloc] init];
    _phoneNumTF.delegate = self;
    _phoneNumTF.placeholder = @"请输入银行预留手机号";
    _phoneNumTF.font = [UIFont systemFontOfSize:14];
    _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumTF.text = user.cellphone;
    UIView *phoneNumTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(phoneNumTFDisrespond) title:@"下一项"];
    [_phoneNumTF setInputAccessoryView:phoneNumTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionDrawalsMoneyTFText:) name:UITextFieldTextDidChangeNotification object:_drawalsMoneyTF];
    
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
    [_drawalsBT setTitle:@"充值" forState:UIControlStateNormal];
    
    _drawalsBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _drawalsBT.backgroundColor=[UIColor typefaceGrayColor];
    _drawalsBT.userInteractionEnabled = NO;
    [FastAnimationAdd codeBindAnimation:_drawalsBT];
    [_drawalsBT addTarget:self action:@selector(checkSureBT:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView reloadData];
}

- (void)checkSureBT:(RoundCornerClickBT *)sender
{
    [MobClick event:@"recharge_click_recharge_btn"];
    if ([_drawalsMoneyTF.text doubleValue] < 500.00) {
        [SVProgressHUD showErrorWithStatus:TheMinimumInvestmentIs500Yuan];
        return;
    }
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    _drawalsBT.userInteractionEnabled = NO;
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] requestQuickPaymentWithCustomerId:user.customerId channel:@"000001" txAmount:_drawalsMoneyTF.text type:@"2" smsCode:_smsAuthNumTF.text authCode:_authCodeStr cellphone:_phoneNumTF.text callback:^(id obj) {
        DLog(@"快速充值返回结果=====%@",obj);
        _drawalsBT.userInteractionEnabled = YES;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                [SVProgressHUD dismiss];
                RechargeAndDrawalsSuccessVC *successVC = [[RechargeAndDrawalsSuccessVC alloc] init];
                successVC.fromStr = _fromStr;
                successVC.amountStr = _drawalsMoneyTF.text;

                UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                UINavigationController *VC = (UINavigationController *)control.selectedViewController;
                UIViewController *productVC = [VC topViewController];
                [productVC.navigationController pushViewController:successVC animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (void)detectionUserInpute {
    
    if (self.drawalsMoneyTF.text.length > 0 && self.smsAuthNumTF.text.length == 6 && self.phoneNumTF.text.length == 11) {
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
    [self.phoneNumTF becomeFirstResponder];
}
- (void)phoneNumTFDisrespond
{
    [self.smsAuthNumTF becomeFirstResponder];
}
- (void)smsAuthTFDisrespond
{
    [self.smsAuthNumTF resignFirstResponder];
}

#pragma -mark textFiledDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self detectionUserInpute];
    
    return YES;
}
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.drawalsMoneyTF) {
        NSCharacterSet *cs;
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        if (dotLocation == NSNotFound && range.location != 0)
        {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
            if (range.location >= 6) {
                if ([string isEqualToString:@"."] && range.location == 6) {
                    return YES;
                }
                return NO;
            }
        } else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
        }
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
        if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
            return NO;
        }
        if (textField.text.length > 9) {
            return NO;
        }
        return YES;
    }
    
    if (textField==self.smsAuthNumTF) {
        if (range.location > 5) {
            return NO;
        }
    }
    if (textField==self.phoneNumTF) {
        if (range.location > 10) {
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
