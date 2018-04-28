
#import "MyBankCardListVC.h"
#import "MyBankCardListCell.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import "WithoutAuthorization.h"
#import "VCAppearManager.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "MyBankNotDataView.h"
#import "UMMobClick/MobClick.h"

@interface MyBankCardListVC () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray           *dataSource;
@property (strong, nonatomic) UIView                   *backContentView;
@property (strong, nonatomic) UITableView              *tableView;
@property (nonatomic, strong) BankAndIdentityInfoModel *bankModel;
@property (nonatomic, strong) UIButton                 *relieveBT;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation MyBankCardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    [self achieveBankDataWith];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)achieveBankDataWith {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
    [[DataRequest sharedClient] obtainUserAlreadyBindCardListWithcustomerId:user.customerId channel:@"000001" callback:^(id obj) {
        [SVProgressHUD dismiss];
        if (!obj) {
            [self notHaveBankList];
            return ;
        }
        if ([obj isKindOfClass:[BankAndIdentityInfoModel class]]) {
            _bankModel = obj;
            if ([_bankModel.canUnbinding intValue] == 1) {
                _relieveBT.hidden = NO;
            }else{
                _relieveBT.hidden = YES;
            }
            if (!self.dataSource) {
                self.dataSource=[NSMutableArray array];
            }
            [self clearBackContentViewSubView];
            [self.dataSource removeAllObjects];
            [self.dataSource addObject:_bankModel];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *BankCardIden=@"banknameinde";
    MyBankCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:BankCardIden];
    if (!cell) {
        cell=[[MyBankCardListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BankCardIden];
    }
    [cell showDetailWithDic:[self.dataSource objectAtIndex:indexPath.row]];
    [cell addSubview:_relieveBT];
    [_relieveBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.equalTo(@50);
        make.centerY.equalTo(cell.mas_centerY);
        make.right.equalTo(cell.mas_right);
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)clearBackContentViewSubView {
    if ([_backContentView subviews] != 0) {
        for (UIView *vi in [_backContentView subviews]) {
            [vi removeFromSuperview];
        }
        [self.view sendSubviewToBack:_backContentView];
    }
    _backContentView.hidden=YES;
}

- (void)notHaveBankList {
    _backContentView.hidden = NO;
    MyBankNotDataView *bankNotData = [[MyBankNotDataView alloc] initWithFrame:CGRectMake(0, 0, 300, 400) noteTitle:@"您还未绑定银行卡" btTitle:@"去绑定"];
    bankNotData.translatesAutoresizingMaskIntoConstraints=NO;
    [self.backContentView addSubview:bankNotData];
    [self.backContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bankNotData]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bankNotData)]];
    [self.backContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bankNotData]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bankNotData)]];
    [self.view bringSubviewToFront:_backContentView];
    [bankNotData bindingBlockWith:^{
        [MobClick event:@"my_bank_card_list_go_band_card_page"];
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        if (user.accountId.length > 0) {
            [VCAppearManager presentBindingBankCardVC:self];
        }else{
            [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
                DLog(@"即时获取用户信息结果====%@",obj);
                if ([obj isKindOfClass:[IndividualInfoManage class]]) {
                    IndividualInfoManage *resultUser=obj;
                    [IndividualInfoManage updateAccountWith:resultUser];
                    if (resultUser.accountId.length == 0) {
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
            }];
        }
    }];
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
                [self notHaveBankList];
                [self achieveCurrentUserInfo];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (void)achieveCurrentUserInfo {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser=obj;
            [IndividualInfoManage updateAccountWith:resultUser];
        }
    }];
}

#pragma -mark UITableViewStyle
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor typefaceGrayColor];
    return view;
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
    _customNav.titleLabel.text = @"我的银行卡";
    self.title = @"我的银行卡";
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _tableView=[[UITableView alloc] init];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.allowsSelection=NO;
    _tableView.bounces = NO;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _relieveBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_relieveBT setTitle:@"解绑" forState:UIControlStateNormal];
    [_relieveBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    _relieveBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [_relieveBT addTarget:self action:@selector(handleRelieveBindingBankCardBT:) forControlEvents:UIControlEventTouchUpInside];
    _relieveBT.hidden = YES;
    
    _backContentView = [[UIView alloc] init];
    [self.view addSubview:_backContentView];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        self.view = nil;
    }
}

@end

