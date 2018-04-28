

#import "IndividualInfoVC.h"
#import "IndividualInfoOneCell.h"
#import "IndividualInfoTwoCell.h"
#import "HTMLVC.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import "VCAppearManager.h"
#import "StringHelper.h"
#import "ModifyLogInPasswordVC.h"
#import "SetGesturePasswordVC.h"
#import "PasswordManageOneCell.h"
#import "PasswordManageTwoCell.h"
#import "UserDefaultsManager.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import "GesturePasswordVC.h"
#import "PromptLanguage.h"
#import "FastAnimationAdd.h"
#import "ExchangePhoneNumberVC.h"
#import "AuditPassOfSilverfoxVC.h"
#import "AuditVC.h"
#import "InspectNetwork.h"
#import "PhoneNumArmisticeVC.h"
#import "RoundCornerClickBT.h"
#import "BankAndIdentityInfoModel.h"

@interface IndividualInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) RoundCornerClickBT *quitLoginBT;
@property (nonatomic, strong) NSMutableArray *oneSectionDatasource;
@property (nonatomic, strong) NSMutableArray *sectionDatasource;
@property (nonatomic, strong) UIButton *changeBT;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BankAndIdentityInfoModel *bankModel;
@property (nonatomic, strong) UIButton *relieveBT;

@end

@implementation IndividualInfoVC
{
    BOOL isCustomer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    self.oneSectionDatasource=[NSMutableArray array];
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    
    _sectionDatasource=[NSMutableArray array];
    [self showPageDetailWith:user];
}

- (void)sureNowCellphoneStatus
{
    if (![InspectNetwork connectedToNetwork]) {
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
        return;
    }
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] startsWithCustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([obj[@"state"] intValue] == 2) {
                    [_changeBT setTitle:@"审核中" forState:UIControlStateNormal];
                    [_changeBT addTarget:self action:@selector(handleTureBT) forControlEvents:UIControlEventTouchUpInside];
                }else if ([obj[@"state"] intValue] == 1){
                    [_changeBT setTitle:@"更换" forState:UIControlStateNormal];
                    [_changeBT addTarget:self action:@selector(handleChangeBT) forControlEvents:UIControlEventTouchUpInside];
                }else if ([obj[@"state"] intValue] == 3){
                    _phoneNum = obj[@"newCellphone"];
                    [_changeBT setTitle:@"审核通过" forState:UIControlStateNormal];
                    [_changeBT addTarget:self action:@selector(handleChangePassBT) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }];
}

- (void)showPageDetailWith:(IndividualInfoManage *)user {
    [_sectionDatasource removeAllObjects];
    [_sectionDatasource addObject:@"修改登录密码"];
    if (user.accountId.length != 0) {
        [_sectionDatasource addObject:@"修改交易密码"];
    }else {
        [self achieveCurrentUserInfo];
    }
    [self.tableView reloadData];
}

- (void)achieveCurrentUserInfo {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser=obj;
            if (resultUser.accountId.length != 0) {
                [IndividualInfoManage updateAccountWith:resultUser];
                [self showPageDetailWith:resultUser];
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self achieveBestNewUser];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)achieveBestNewUser {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser=obj;
            [IndividualInfoManage updateAccountWith:resultUser];
            [self ensureUserInfoWith:resultUser];
        }
    }];
}

- (void)ensureUserInfoWith:(IndividualInfoManage *)user {
    if (user.name.length != 0) {
        isCustomer=YES;
    }else{
        isCustomer=NO;
    }
    if (user.name.length > 0) {
        _changeBT.hidden = NO;
        [self sureNowCellphoneStatus];
    }else{
        _changeBT.hidden = YES;
    }
    [self.oneSectionDatasource removeAllObjects];
    if (isCustomer) {
        NSString *accStr = [user.cellphone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        NSDictionary *oneDic=@{@"name":@"手机号",@"value":accStr};
        [self.oneSectionDatasource addObject:oneDic];
        NSString *nameStr = [StringHelper coverUserNameWith:user.name];
        NSDictionary *twoDic=@{@"name":@"真实姓名",@"value":nameStr};
        [self.oneSectionDatasource addObject:twoDic];
        
        NSString *idCardStr=[user.idcard stringByReplacingCharactersInRange:NSMakeRange(4, 10) withString:@"**********"];
        NSDictionary *threeDic=@{@"name":@"身份证号",@"value":idCardStr};
        [self.oneSectionDatasource addObject:threeDic];
        
        [[DataRequest sharedClient] obtainUserAlreadyBindCardListWithcustomerId:user.customerId channel:@"000001" callback:^(id obj) {
            if ([obj isKindOfClass:[BankAndIdentityInfoModel class]]) {
                _bankModel = obj;
                NSString *imageStr=_bankModel.bankNO;
                NSString *bankNumStr=_bankModel.cardNO;
                NSAttributedString *arrStr = [StringHelper renderImageAndTextWithValue:[NSString stringWithFormat:@" %@ (尾号%@)",_bankModel.bankName,[bankNumStr substringWithRange:NSMakeRange(bankNumStr.length-4, 4)]] valueFont:15 valueColor:[UIColor characterBlackColor] image:[UIImage imageNamed:imageStr] imageFrame:CGRectMake(0, -6, 23, 23) index:0];
                NSDictionary *fourDic = @{@"name":@"银行卡",@"value":arrStr};
                [self.oneSectionDatasource addObject:fourDic];
                [self.tableView reloadData];
            }
        }];
    } else {
        NSString *accStr=[user.cellphone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        NSDictionary *oneDic = @{@"name":@"手机号",@"value":accStr};
        [self.oneSectionDatasource addObject:oneDic];
        
        NSString *arrStr = @"去绑定";
        NSDictionary *fourDic = @{@"name":@"银行卡",@"value":arrStr};
        [self.oneSectionDatasource addObject:fourDic];
    }
    
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 100;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 || section == 3) {
        return 0;
    }
    return 20;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor backgroundGrayColor];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return _oneSectionDatasource.count;
            break;
        case 1:return _sectionDatasource.count;
            break;
        case 2:return 1;
            break;
        default:
            break;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *oneCellIndetifier=@"IndividualInfoOneCell";
        IndividualInfoOneCell *oneCell = [tableView dequeueReusableCellWithIdentifier:oneCellIndetifier];
        if (!oneCell) {
            oneCell=[[IndividualInfoOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oneCellIndetifier];
        }
        if (indexPath.row == 0) {
            [_changeBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
            _changeBT.titleLabel.textAlignment = NSTextAlignmentRight;
            _changeBT.titleLabel.font = [UIFont systemFontOfSize:15];
            _changeBT.frame = CGRectMake(self.view.frame.size.width - 90, 10, 90, 30);
            [oneCell addSubview:_changeBT];
        }

        if (indexPath.row == _oneSectionDatasource.count - 1) {
            _relieveBT.frame = CGRectMake(self.view.frame.size.width - 90, 10, 90, 30);
            if ([_bankModel.canUnbinding intValue] == 1) {
                _relieveBT.hidden = NO;
            } else {
                _relieveBT.hidden = YES;
            }
            [oneCell addSubview:_relieveBT];
        }
        if (self.oneSectionDatasource.count != 0) {
            [oneCell showDetailWithDic:[self.oneSectionDatasource objectAtIndex:[indexPath row]]];
        }
        oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return oneCell;
    }
    
    if (indexPath.section == 1) {
        static NSString *oneIndentifier=@"PasswordManageOneCell";
        PasswordManageOneCell *cell=[tableView dequeueReusableCellWithIdentifier:oneIndentifier];
        if (!cell) {
            cell=[[PasswordManageOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oneIndentifier];
        }
        [cell showDetailWith:[self.sectionDatasource objectAtIndex:indexPath.row]];
        return cell;
    }
    if (indexPath.section == 2) {
        static NSString *twoIndentifier = @"PasswordManageTwoCell";
        PasswordManageTwoCell *cell=[tableView dequeueReusableCellWithIdentifier:twoIndentifier];
        if (!cell) {
            cell=[[PasswordManageTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:twoIndentifier];
        }
        cell.titleLB.text = @"手势解锁";
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell openGesturePasswordWith:^(BOOL isOpen) {
            if (isOpen) {
                [MobClick event:@"gesture_pwd_open"];
                SetGesturePasswordVC *setGesture=[[SetGesturePasswordVC alloc] init];
                [self presentViewController:setGesture animated:YES completion:nil];
            } else {
                [MobClick event:@"gesture_pwd_close"];
                GesturePasswordVC *gestureVC = [[GesturePasswordVC alloc] init];
                [gestureVC passCloseEventWith:^{
                    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
                    if (user) {
                        [UserDefaultsManager clearUserGesturePasswordWith:user.customerId];
                    }
                }];
                [self presentViewController:gestureVC animated:YES completion:nil];
            }
        }];
        return cell;
    }
    
    if (indexPath.section==3) {
        UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor backgroundGrayColor];
        [cell addSubview:_quitLoginBT];
        [_quitLoginBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(30);
            make.height.equalTo(@45);
            make.left.equalTo(cell.mas_left).offset(43);
            make.right.equalTo(cell.mas_right).offset(-43);
        }];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (indexPath.section == 0) {
        if ((indexPath.row == _oneSectionDatasource.count - 1) && !_bankModel) {
            if (user.accountId.length == 0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还未开通银行存管账户\n是否开通?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"立即开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [VCAppearManager presentPersonalAmountCurrentVC:self];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:otherAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }else{
                BindingBankCardVC *bindingVC = [[BindingBankCardVC alloc] init];
                [self.navigationController pushViewController:bindingVC animated:YES];
            }
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [MobClick event:@"update_login_pwd"];
            ModifyLogInPasswordVC *modify=[[ModifyLogInPasswordVC alloc] init];
            [self.navigationController pushViewController:modify animated:YES];
        }
        if (indexPath.row==1) {
            [MobClick event:@"update_trade_pwd"];
            [VCAppearManager presentToResetTraderPasswordCurrentVC:self];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (void)UIDecorate {
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"个人中心";
    self.title = @"个人中心";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.tableView = [[UITableView alloc] init];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _quitLoginBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_quitLoginBT setTitle:@"退出登录" forState:UIControlStateNormal];
    _quitLoginBT.titleLabel.font=[UIFont systemFontOfSize:17];
    [FastAnimationAdd codeBindAnimation:_quitLoginBT];
    _quitLoginBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
    [_quitLoginBT addTarget:self action:@selector(quitLogIn:) forControlEvents:UIControlEventTouchUpInside];
    
    _changeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _relieveBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_relieveBT setTitle:@"解绑" forState:UIControlStateNormal];
    [_relieveBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    _relieveBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [_relieveBT addTarget:self action:@selector(handleRelieveBindingBankCardBT:) forControlEvents:UIControlEventTouchUpInside];
    _relieveBT.hidden = YES;
}

- (void)handleRelieveBindingBankCardBT:(UIButton *)sender
{
    [MobClick event:@"my_bank_card_list_go_band_card_page"];
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    _relieveBT.userInteractionEnabled = NO;
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]requsetRelieveBankCardWithCustomerId:user.customerId cardNo:_bankModel.cardNO channel:@"000001" callback:^(id obj) {
        _relieveBT.userInteractionEnabled = YES;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                [SVProgressHUD dismiss];
                [self.oneSectionDatasource removeObjectAtIndex:self.oneSectionDatasource.count-1];
                NSString *arrStr = @"去绑定";
                NSDictionary *fourDic = @{@"name":@"银行卡",@"value":arrStr};
                [self.oneSectionDatasource addObject:fourDic];
                [self.tableView reloadData];
                //[self achieveCurrentUserInfo];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (void)quitLogIn:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您确定要退出登录吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MobClick event:@"usercenter_exit"];
        IndividualInfoManage *user=[IndividualInfoManage currentAccount];
        if (!user) {
            return;
        }
        [self userQuitLogin:user.customerId];
        [UserInfoUpdate clearUserLocalInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)handleChangeBT
{
    [MobClick event:@"usercenter_change_phone"];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (user.accountId.length > 0) {
        ExchangePhoneNumberVC *exchangeNum = [[ExchangePhoneNumberVC alloc] init];
        [self.navigationController pushViewController:exchangeNum animated:YES];
    } else {
        PhoneNumArmisticeVC *armosticeVC = [[PhoneNumArmisticeVC alloc] init];
        [self.navigationController pushViewController:armosticeVC animated:YES];
    }
}

- (void)handleTureBT
{
    AuditVC *auditVC = [[AuditVC alloc] init];
    [self.navigationController pushViewController:auditVC animated:YES];
}

- (void)handleChangePassBT
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (user.accountId.length > 0) {
        AuditPassOfSilverfoxVC *passVC = [[AuditPassOfSilverfoxVC alloc] init];
        passVC.phoneNum = self.phoneNum;
        [self.navigationController pushViewController:passVC animated:YES];
    }else{
        [VCAppearManager presentPersonalAmountCurrentVC:self];
    }
}

- (void)userQuitLogin:(NSString *)customerId {
    [MobClick event:@"more_exit"];
    [[DataRequest sharedClient] quitLoginWithcustomerId:customerId];
}


@end
