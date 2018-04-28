
#import "GoodsChangeVC.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import "Validation.h"
#import "AddCancelButton.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "AddBankCardCell.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "ChangerRecordVC.h"
#import "StringHelper.h"
#import "SignHelper.h"
#import "SCMeasureDump.h"
#import "SkyerCityPicker.h"
#import "UMMobClick/MobClick.h"

@interface GoodsChangeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITextField *nameTF;
@property (strong, nonatomic) UITextField *idCardTF;
@property (nonatomic, strong) UIButton *addressBT;
@property (nonatomic, strong) UITextField *detailAddressTF;
@property (strong, nonatomic) RoundCornerClickBT *nextStepBT;
@property (nonatomic, strong) UIButton *sendAuthCodeBT;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GoodsChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
}

- (void)UIDecorate {
    self.view.backgroundColor=[UIColor backgroundGrayColor];
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"商品兑换";
    self.title = @"商品兑换";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    _tableView=[[UITableView alloc] init];
    _tableView.backgroundColor=[UIColor backgroundGrayColor];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.allowsSelection=NO;
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    
    //姓名输入框
    _nameTF = [[UITextField alloc] init];
    _nameTF.delegate = self;
    _nameTF.font = [UIFont systemFontOfSize:14];
    _nameTF.placeholder = @"请输入收货人姓名";
    _nameTF.text = user.name;
    _nameTF.textColor = [UIColor characterBlackColor];
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *nameTFDis = [AddCancelButton addCompleteBTOnVC:self withSelector:@selector(nameTFrespond) title:@"完成"];
    [self.nameTF setInputAccessoryView:nameTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionNameTFText:) name:UITextFieldTextDidChangeNotification object:self.nameTF];
    
    //手机号输入框
    _idCardTF = [[UITextField alloc] init];
    _idCardTF.delegate = self;
    _idCardTF.placeholder = @"请输入收货人手机号";
    _idCardTF.text = user.cellphone;
    _idCardTF.textColor = [UIColor characterBlackColor];
    _idCardTF.font=[UIFont systemFontOfSize:14];
    _idCardTF.keyboardType = UIKeyboardTypeDecimalPad;
    _idCardTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *idCardTFDis = [AddCancelButton addCompleteBTOnVC:self withSelector:@selector(idCardTFrespond) title:@"完成"];
    [self.idCardTF setInputAccessoryView:idCardTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionIdCardTFText:) name:UITextFieldTextDidChangeNotification object:self.idCardTF];
    
    //省市区地址输入框
    _addressBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressBT.titleLabel.font=[UIFont systemFontOfSize:14];
    [_addressBT setTitle:@"省-市-区/县" forState:UIControlStateNormal];
    [_addressBT setTitleColor:[UIColor typefaceGrayColor] forState:UIControlStateNormal];
    [_addressBT addTarget:self action:@selector(clickCtiyChoose:) forControlEvents:UIControlEventTouchUpInside];
    _addressBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐
    
    //详细地址输入框
    _detailAddressTF = [[UITextField alloc] init];
    _detailAddressTF.delegate = self;
    _detailAddressTF.placeholder = @"请输入详细邮寄地址,以便客服发货";
    _detailAddressTF.font = [UIFont systemFontOfSize:14];
    _detailAddressTF.textColor = [UIColor characterBlackColor];
    _detailAddressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *detailAddressTFDis = [AddCancelButton addCompleteBTOnVC:self withSelector:@selector(detailAddressTFDisrespond) title:@"完成"];
    [self.detailAddressTF setInputAccessoryView:detailAddressTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionDetailAddressTFText:) name:UITextFieldTextDidChangeNotification object:self.detailAddressTF];
    
    
    _nextStepBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_nextStepBT setTitle:@"确认兑换" forState:UIControlStateNormal];
    _nextStepBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
    _nextStepBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_nextStepBT];
    [_nextStepBT addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView reloadData];
}

- (void)nextStep:(UIButton *)sender {
    [self silverTraderChangeCodeSig];
}

- (void)silverTraderChangeCodeSig
{
    NSString *addressStr = [NSString stringWithFormat:@"%@--%@",self.addressBT.titleLabel.text,_detailAddressTF.text];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] silverTraderChangePagecustomerId:user.customerId goodsId:_idStr name:self.nameTF.text cellphone:self.idCardTF.text address:addressStr callback:^(id obj) {
        DLog(@"兑换结果======%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                [MobClick event:@"silver_goods_exchange_success"];
                [[SensorsAnalyticsSDK sharedInstance] track:@"GoodsExchange"
                                             withProperties:@{
                                                              @"GoodsName" : _nameStr,
                                                              @"CostSilver":@([_consumeStr intValue]),
                                                              }];
                [self entranceRetrieveExchangePasswordVC];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor backgroundGrayColor];
        UILabel *titleLB = [[UILabel alloc] init];
        [cell addSubview:titleLB];
        
        titleLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"兑换该商品需要消耗" frontFont:15 frontColor:[UIColor characterBlackColor] afterStr:[NSString stringWithFormat:@"%@两",self.consumeStr]  afterFont:15 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"银子" lastFont:15 lastColor:[UIColor characterBlackColor]];
        titleLB.textAlignment = NSTextAlignmentCenter;
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        return cell;
    }
    
    if (indexPath.row == 1) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"姓名" inputTF:_nameTF leftViewWidth:70];
        return cell;
    }
    
    if (indexPath.row == 2) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"手机号" inputTF:_idCardTF leftViewWidth:70];
        return cell;
    }
    if (indexPath.row == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *label = [[UILabel alloc] init];
        [cell addSubview:label];
        label.text = @"收货地址";
        label.textColor = [UIColor characterBlackColor];
        label.font = [UIFont systemFontOfSize:16];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(15);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.equalTo(@20);
        }];
        
        [cell addSubview:_addressBT];
        [_addressBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(85);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.equalTo(@50);
            make.right.equalTo(cell.mas_right);
        }];
        
        UILabel *labelLine = [[UILabel alloc] init];
        labelLine.backgroundColor = [UIColor typefaceGrayColor];
        [cell addSubview:labelLine];
        [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(15);
            make.bottom.equalTo(cell.mas_bottom);
            make.height.equalTo(@0.5);
            make.right.equalTo(cell.mas_right);
        }];
        
        return cell;
    }
    if (indexPath.row == 4) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"详细地址" inputTF:_detailAddressTF leftViewWidth:70];
        return cell;
    }
    if (indexPath.row == 5) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return 80;
            break;
        case 5:
            return 150;
            break;
        default:
            break;
    }
    return 60;
}

- (void)entranceRetrieveExchangePasswordVC {
    ChangerRecordVC *recordVC = [[ChangerRecordVC alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)detectionUserInpute {
    if (self.nameTF.text.length >= 1 && self.idCardTF.text.length >= 11 && _addressBT.titleLabel.text.length > 0 && _detailAddressTF.text.length > 0) {
        self.nextStepBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
        self.nextStepBT.userInteractionEnabled = YES;
    } else {
        self.nextStepBT.backgroundColor=[UIColor typefaceGrayColor];
        self.nextStepBT.userInteractionEnabled=NO;
    }
}

//姓名输入框 检测
- (void)detectionNameTFText:(NSNotification *)note
{
    [self detectionUserInpute];
}

//手机号输入框 检测
- (void)detectionIdCardTFText:(NSNotification *)note
{
    [self detectionUserInpute];
}

//详细地址输入框
- (void)detectionDetailAddressTFText:(NSNotification *)note
{
    [self detectionUserInpute];
}

- (void)nameTFrespond {
    [self.nameTF resignFirstResponder];
}

- (void)idCardTFrespond {
    [self.idCardTF resignFirstResponder];
}

- (void)clickCtiyChoose:(UIButton *)sender
{
    [self.nameTF resignFirstResponder];
    [self.idCardTF resignFirstResponder];
    [self.detailAddressTF resignFirstResponder];
    SkyerCityPicker *skyerCityPicker=[[SkyerCityPicker alloc] init];
    __weak typeof(self)weakSelf = self;
    [skyerCityPicker cityPikerGetSelectCity:^(NSMutableDictionary *dicSelectCity)
     {
         DLog(@"dicSelectCity=%@",dicSelectCity);
         weakSelf.dict = dicSelectCity;
         [self chooseCity:_dict];
     }];
}

- (void)chooseCity:(NSMutableDictionary *)dic
{
    [_addressBT setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
    NSString *cityStr = [NSString stringWithFormat:@"%@%@%@",dic[@"Province"],dic[@"City"],dic[@"District"]];
    [_addressBT setTitle:cityStr forState:UIControlStateNormal];
    [self detectionUserInpute];
}

- (void)detailAddressTFDisrespond
{
    [self.detailAddressTF resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma -mark textFiledDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self detectionUserInpute];
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==self.idCardTF) {
        if (range.location>10) {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

