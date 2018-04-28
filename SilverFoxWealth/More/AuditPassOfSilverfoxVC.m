//
//  AuditPassOfSilverfoxVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AuditPassOfSilverfoxVC.h"
#import "UILabel+LabelStyle.h"
#import "RoundCornerClickBT.h"
#import "AnewSendBT.h"
#import "FastAnimationAdd.h"
#import "AddCancelButton.h"
#import "AddBankCardCell.h"
#import "DataRequest.h"
#import "PromptLanguage.h"
#import "SignHelper.h"
#import "Validation.h"
#import "SVProgressHUD.h"
#import "DispatchHelper.h"
#import "AuditPassOfJXBankVC.h"

@interface AuditPassOfSilverfoxVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UILabel *phoneStatus;
@property (nonatomic, strong) RoundCornerClickBT  *drawalsBT;
@property (nonatomic, strong) AnewSendBT *afreshSendBT;
@property (nonatomic, strong) UITextField *smsAuthNumTF;
@property (nonatomic, strong) UITextField *cellphoneTF;
@property (nonatomic, strong) NSString  *authCodeStr;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AuditPassOfSilverfoxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=[UIColor backgroundGrayColor];
    self.tableView.scrollEnabled = NO;//不能滑动
    
    _cellphoneTF = [[UITextField alloc] init];
    _cellphoneTF.font=[UIFont systemFontOfSize:14];
    _cellphoneTF.enabled = NO;
    _cellphoneTF.text = _phoneNum;
    _cellphoneTF.textColor = [UIColor characterBlackColor];
    
    _smsAuthNumTF = [[UITextField alloc] init];
    _smsAuthNumTF.delegate = self;
    _smsAuthNumTF.placeholder = @"请输入短信验证码";
    _smsAuthNumTF.textColor = [UIColor characterBlackColor];
    _smsAuthNumTF.font = [UIFont systemFontOfSize:14];
    _smsAuthNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _smsAuthNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *authCodeTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(smsAuthTFDisrespond) title:@"完成"];
    [_smsAuthNumTF setInputAccessoryView:authCodeTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionAuthCodeTFText:) name:UITextFieldTextDidChangeNotification object:_smsAuthNumTF];
    
    _drawalsBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_drawalsBT setTitle:@"下一步" forState:UIControlStateNormal];
    
    _drawalsBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _drawalsBT.backgroundColor=[UIColor typefaceGrayColor];
    _drawalsBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_drawalsBT];
    [_drawalsBT addTarget:self action:@selector(checkSureBT:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)checkSureBT:(UIButton *)sender
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]exchangeNewPhoneNumberForCensorCodeWithCellphone:_phoneNum smsCode:_smsAuthNumTF.text authCode:_authCodeStr channel:@"000001" accountId:user.accountId callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                AuditPassOfJXBankVC *passVC = [[AuditPassOfJXBankVC alloc] init];
                [self.navigationController pushViewController:passVC animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (void)smsAuthTFDisrespond
{
    [self.smsAuthNumTF resignFirstResponder];
}
- (void)detectionUserInpute {
    
    if (self.smsAuthNumTF.text.length == 6) {
        self.drawalsBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.drawalsBT.userInteractionEnabled=YES;
    }else {
        self.drawalsBT.backgroundColor=[UIColor typefaceGrayColor];
        self.drawalsBT.userInteractionEnabled=NO;
    }
}

- (void)detectionAuthCodeTFText:(NSNotification *)note {
    [self detectionUserInpute];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 150;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc] init];
    _phoneStatus = [[UILabel alloc] init];
    _phoneStatus.numberOfLines = 0;
    _phoneStatus.text = @"您提交的资料已审核通过\n请验证新手机号";
    [_phoneStatus decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor characterBlackColor]];
    _phoneStatus.textAlignment = NSTextAlignmentCenter;
    [customView addSubview:_phoneStatus];
    _phoneStatus.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 50);
    return customView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"手机号" inputTF:_cellphoneTF leftViewWidth:90];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row == 1) {
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
    if (indexPath.row == 2) {
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

- (void)checkSendAuthCodeBT:(UIButton *)sender
{
    [DispatchHelper afreshSendShortMessageWith:_afreshSendBT];
    [[DataRequest sharedClient] requestJXBankSmsCodeWithCellphone:_phoneNum serviceCode:@"mobileModifyPlus" channel:@"000001" callback:^(id obj) {
        DLog(@"审核通过,更换手机号发送验证码=====%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            _authCodeStr = obj[@"authCode"];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            [SVProgressHUD showErrorWithStatus:obj];
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (textField==self.smsAuthNumTF) {
        if (range.location > 5) {
            return NO;
        }
    }
    return YES;
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

