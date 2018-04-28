//
//  QuickDrawalsVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "QuickDrawalsVC.h"
#import "AddBankCardCell.h"
#import "RoundCornerClickBT.h"
#import "AddCancelButton.h"
#import "FastAnimationAdd.h"
#import "SVProgressHUD.h"
#import "UILabel+LabelStyle.h"
#import "SCMeasureDump.h"
#import "DataRequest.h"
#import "StringHelper.h"
#import "CommitDrawalsInfoWebView.h"
#import "BindingBankCardVC.h"
#import "UMMobClick/MobClick.h"

@interface QuickDrawalsVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *usableAssetTF;
@property (nonatomic, strong) UITextField *bankInfoTF;
@property (nonatomic, strong) UITextField *drawalsAmountTF;
@property (nonatomic, strong) UITextField *factorageTF;
@property (nonatomic, strong) UITextField *realityArrivalTF;
@property (nonatomic, strong) UILabel *drawalsTime;
@property (nonatomic, strong) RoundCornerClickBT *drawalsBT;
@property (nonatomic, strong) UILabel *infoLB;
@property (nonatomic, assign)  double amount;
@property (nonatomic, strong) NSString *toGroupAmount;

@end

@implementation QuickDrawalsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    [self addNewMessageObserve];
    // Do any additional setup after loading the view.
}

- (void)addNewMessageObserve {
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(addMessageNoteWith) name:@"withrowShow" object:nil];
}

- (void)addMessageNoteWith
{
    if (_freeTimesStr) {
        _drawalsTime.text = [NSString stringWithFormat:@"每月免费提现%@次, 剩余%@次",_totalStr,_freeTimesStr];
    }else{
        _drawalsTime.text = @"每月免费提现3次, 剩余 次";
    }
    self.tableView.userInteractionEnabled = YES;
    _drawalsBT.userInteractionEnabled = YES;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 450;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"可用资产" inputTF:_usableAssetTF leftViewWidth:90];
        _usableAssetTF.textColor = [UIColor zheJiangBusinessRedColor];
        if (_balanceStr) {
            _usableAssetTF.text = [NSString stringWithFormat:@"%.2f元",floor([_balanceStr doubleValue] *100) / 100];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"到账银行卡" inputTF:_bankInfoTF leftViewWidth:90];
        _bankInfoTF.textColor = [UIColor iconBlueColor];
        if (_bankInfoStr) {
            _bankInfoTF.text = _bankInfoStr;
        }else{
            _bankInfoTF.text = @"绑定银行卡";
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 2) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"提现金额" inputTF:_drawalsAmountTF leftViewWidth:90];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 3) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"手续费" inputTF:_factorageTF leftViewWidth:90];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 4) {
        AddBankCardCell *cell = [[AddBankCardCell alloc] initWithTitle:@"实际到账" inputTF:_realityArrivalTF leftViewWidth:90];
        _realityArrivalTF.textColor = [UIColor zheJiangBusinessRedColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 5) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor=[UIColor backgroundGrayColor];
        [cell addSubview:_drawalsBT];
        [cell addSubview:_drawalsTime];
        [cell addSubview:_infoLB];
        [_drawalsTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(5);
            make.height.equalTo(@20);
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right);
        }];
        [_drawalsBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(50);
            make.height.equalTo(@45);
            make.left.equalTo(cell.mas_left).offset(43);
            make.right.equalTo(cell.mas_right).offset(-43);
        }];
        [_infoLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_drawalsBT.mas_bottom).offset(20);
            make.height.equalTo(@180);
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
        }];
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        if (!_bankInfoStr) {
            [MobClick event:@"withdraw_page_go_band_card"];
            BindingBankCardVC *bindVC = [[BindingBankCardVC alloc] init];
            bindVC.rechargeType = @"drawals";
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *VC=(UINavigationController *)control.selectedViewController;
            UIViewController *productVC=[VC topViewController];
            [productVC.navigationController pushViewController:bindVC animated:YES];
        }
    }
}

- (void)UIDecorate {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor=[UIColor backgroundGrayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.tableView.bounces = NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    headView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.tableHeaderView = headView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.userInteractionEnabled = NO;
    
    _usableAssetTF = [[UITextField alloc] init];
    _usableAssetTF.textAlignment = NSTextAlignmentRight;
    _usableAssetTF.text = @"0.00元";
    _usableAssetTF.enabled = NO;
    
    _bankInfoTF = [[UITextField alloc] init];
    _bankInfoTF.enabled = NO;
    
    _drawalsAmountTF = [[UITextField alloc] init];
    _drawalsAmountTF.delegate = self;
    _drawalsAmountTF.placeholder = @"请输入提现金额";
    _drawalsAmountTF.font = [UIFont systemFontOfSize:14];
    _drawalsAmountTF.keyboardType = UIKeyboardTypeDecimalPad;
    _drawalsAmountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *authCardNOTFDis = [AddCancelButton addCompleteBTOnVC:self withSelector:@selector(drawalsMoneyTFDisrespond) title:@"完成"];
    [_drawalsAmountTF setInputAccessoryView:authCardNOTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionDrawalsMoneyTFText:) name:UITextFieldTextDidChangeNotification object:_drawalsAmountTF];
    
    _factorageTF = [[UITextField alloc] init];
    _factorageTF.font = [UIFont systemFontOfSize:14];
    _factorageTF.textColor = [UIColor characterBlackColor];
    _factorageTF.text = @"0.00元";
    _factorageTF.enabled = NO;
    
    _realityArrivalTF = [[UITextField alloc] init];
    _realityArrivalTF.font = [UIFont systemFontOfSize:14];
    _realityArrivalTF.text = @"0.00元";
    _realityArrivalTF.enabled = NO;
    
    _drawalsTime = [[UILabel alloc] init];
    _drawalsTime.text = @"每月免费提现3次, 剩余 次";
    [_drawalsTime decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor depictBorderGrayColor]];
    
    _drawalsBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_drawalsBT setTitle:@"提现" forState:UIControlStateNormal];
    _drawalsBT.titleLabel.font = [UIFont systemFontOfSize:16];
    _drawalsBT.backgroundColor = [UIColor typefaceGrayColor];
    _drawalsBT.userInteractionEnabled = NO;
    [FastAnimationAdd codeBindAnimation:_drawalsBT];
    [_drawalsBT addTarget:self action:@selector(checkSureBT:) forControlEvents:UIControlEventTouchUpInside];
    
    _infoLB = [[UILabel alloc] init];
    _infoLB.numberOfLines = 0;
    _infoLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"提现规则:\n" frontFont:13 frontColor:[UIColor characterBlackColor] afterStr:@"1. 江西银行电子账户采用同卡进出设置, 资金只能提现至您本人充值的银行卡;\n2. 快速提现: 支持5万及以下资金提现, 实时到账, 支持节假日;\n3. 大额提现: 工作日9:00-16:30期间提现, 到账时间为30分钟左右; 16:30之后无法提现;\n4. 每人每月可享受一定的提现次数，会员等级越高，免费提现次数越多，超出免费提现次数后按提现金额0.15%收取提现手续费，不足1元按1元计算;\n5. 如果提现出现疑问, 请拨打客服电话咨询400-021-8855。" afterFont:12 afterColor:[UIColor depictBorderGrayColor]];
}

- (void)checkSureBT:(RoundCornerClickBT *)sender
{
    [MobClick event:@"withdraw_click_withdraw_btn"];
    _drawalsBT.userInteractionEnabled = NO;
    if ([_drawalsAmountTF.text intValue] > 50000) {
        [SVProgressHUD showErrorWithStatus:@"快速提现每次最多提现5万元"];
        _drawalsBT.userInteractionEnabled = YES;
        return;
    }
    if ([_toGroupAmount doubleValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"提现金额必须大于手续费"];
        _drawalsBT.userInteractionEnabled = YES;
        return;
    }
    
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    DLog(@"点击提现");
    [[DataRequest sharedClient]requsetPaymentsWithdrawWithCustomerId:user.customerId accountId:user.accountId provinceBankNO:@"" cardNO:_cardNOStr principal:_drawalsAmountTF.text channel:@"000001" detailChannel:@"2" callback:^(id obj) {
        DLog(@"提现返回信息====%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                CommitDrawalsInfoWebView *commitView = [[CommitDrawalsInfoWebView alloc] init];
                commitView.provinceBankNO = @"";
                commitView.principal = _drawalsAmountTF.text;
                commitView.cardNO = _cardNOStr;
                UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                UINavigationController *VC = (UINavigationController *)control.selectedViewController;
                UIViewController *productVC = [VC topViewController];
                commitView.hidesBottomBarWhenPushed = YES;
                [productVC.navigationController pushViewController:commitView animated:YES];
            }else{
                _drawalsBT.userInteractionEnabled = YES;
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (void)detectionUserInpute {
    if (self.drawalsAmountTF.text.length > 0 && _bankInfoStr) {
        self.drawalsBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
        self.drawalsBT.userInteractionEnabled = YES;
    }else {
        self.drawalsBT.backgroundColor = [UIColor typefaceGrayColor];
        self.drawalsBT.userInteractionEnabled = NO;
    }
}

- (void)detectionDrawalsMoneyTFText:(NSNotification *)note
{
    [self detectionUserInpute];
    if ([_freeTimesStr intValue] > 0) {
        _amount = 0.00;
        _factorageTF.text = [NSString stringWithFormat:@"%.2f元",_amount];
        _toGroupAmount = _drawalsAmountTF.text;
        _realityArrivalTF.text = [NSString stringWithFormat:@"%.2f元",[_drawalsAmountTF.text doubleValue]];
    } else {
        _amount = [_drawalsAmountTF.text doubleValue] * 0.0015;
        if (_amount < 1 && _amount > 0) {
            _amount = 1.00;
        }else if(_amount == 0){
            _amount = 0;
        }
        _factorageTF.text = [NSString stringWithFormat:@"%.2f元",_amount];
        if ([_drawalsAmountTF.text doubleValue] - _amount < 0) {
            _drawalsAmountTF.text = @"0";
            _realityArrivalTF.text = @"0.00元";
        }else{
            NSString *amountStr = [NSString stringWithFormat:@"%.2f",_amount];
            _toGroupAmount = [NSString stringWithFormat:@"%.2f",[_drawalsAmountTF.text doubleValue] - [amountStr doubleValue]];
            _realityArrivalTF.text = [NSString stringWithFormat:@"%.2f元",[_drawalsAmountTF.text doubleValue] - [amountStr doubleValue]];
        }
    }
}

- (void)drawalsMoneyTFDisrespond
{
    [self.drawalsAmountTF resignFirstResponder];
}

#pragma -mark textFiledDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self detectionUserInpute];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.drawalsAmountTF) {
        if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""])) {
            return NO;
        }
        NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
        [str insertString:string atIndex:range.location];
        if (str.length >= [str rangeOfString:@"."].location+4) {
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
