

#import "ProductBuyBaseVC.h"
#import "InspectNetwork.h"
#import <SVProgressHUD.h>
#import "DataRequest.h"
#import "DateHelper.h"
#import "StringHelper.h"
#import "RoundCornerBT.h"
#import "FastAnimationAdd.h"
#import "WithoutAuthorization.h"
#import "VCAppearManager.h"
#import "SilverWealthProductModel.h"
#import "EstimateRebateUsefulness.h"
#import "LastTimeUseBankModel.h"
#import "RechargeVC.h"
#import "CommitBuyInfoWebview.h"
#import "PromptLanguage.h"

#ifdef ViOS8
#import <LocalAuthentication/LocalAuthentication.h>
#endif

@interface ProductBuyBaseVC()

@property (strong , nonatomic)UIButton *agreeBT;
@property (nonatomic, copy) SilverWealthProductModel   *resultSilverWealthProduct;
@property (nonatomic, strong) NSDictionary *LLDict;
@property (nonatomic, strong) NSString *orderNumStr;
@property (nonatomic, strong) NSString *signStr;//签名str

@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) NSString *signBuy;
@property (nonatomic, strong) NSString *messageStr;
@property (nonatomic, strong) SilverWealthProductDetailModel *productDetailModel;
@property (nonatomic, strong) NSArray *orderArray;
@property (nonatomic, strong) LastTimeUseBankModel *lastTimeModel;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation ProductBuyBaseVC
{
    BOOL isCanUseRebate;
    BOOL isTime;
}
- (void)viewDidLoad {
    isCanUseRebate = YES;
    isTime = NO;
    [super viewDidLoad];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"购买";
    self.title = @"购买";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    weakSelf.customNav.leftViewController = ^{
        if (![_backType isEqualToString:@"productList"]) {
            [self accessFirstVC];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [self addBaseView];
    
    self.incomeTimeLB.text=[self estimateIncomeTime];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    [self achieveUserAmount];
}

- (NSString *)achieveUserAmount
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]requestUserBalanceAmountWithCustomerId:user.customerId channel:@"000001" callback:^(id obj) {
        [SVProgressHUD dismiss];
        DLog(@"购买页面可用余额=======%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            _balanceStr = obj[@"balance"];
            _bankCardLB.text = [NSString stringWithFormat:@"%.2f元",floor([_balanceStr doubleValue] *100) / 100];
            NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
            [messageCenter postNotificationName:@"balanceShow" object:Nil userInfo:nil];
        }
    }];
    return _balanceStr;
}

//预计产生收益的时间
- (NSString *)estimateIncomeTime  {
    if (self.buyProductInfo.interestDate.length == 0) {
        return @"T+1起息";
    }
    return self.buyProductInfo.interestDate;
}

//产品购买
- (void)buyProduct:(UIButton *)BT {
    [MobClick event:@"buy_commit_btn"];
    _commitBT.userInteractionEnabled = NO;
    if (self.buyProductInfo.highestMoney.length != 0) {
        if ([_principalStr intValue] > [self.buyProductInfo.highestMoney floatValue]) {
            NSString *residueAmoutStr=[PromptLanguage buyNumAmountSuperscaleWithAmount:self.buyProductInfo.highestMoney];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:residueAmoutStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            _commitBT.userInteractionEnabled = YES;
            return;
        }
    }
    
    if ([InspectNetwork connectedToNetwork]) {
        [self confirmationProductInfo];
    }else {
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
}

- (void)confirmationProductInfo
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    NSString *couponId = [self caculateCurrentRebateId];
    [[DataRequest sharedClient] requestConfirmationProductInfoWithCustomerId:user.customerId name:user.name idcard:user.idcard channel:@"000001" accountId:user.accountId productId:_buyProductInfo.productId principal:_principalStr customerCouponId:couponId detailChannel:@"2" callback:^(id obj) {
        DLog(@"购买返回结果=======%@",obj);
        _commitBT.userInteractionEnabled = YES;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                [self pushToCommitBuyInfoWebView];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (void)pushToCommitBuyInfoWebView
{
    CommitBuyInfoWebview *buyView = [[CommitBuyInfoWebview alloc] init];
    buyView.productId = _buyProductInfo.productId;
    [self.navigationController pushViewController:buyView animated:YES];
}

#pragma -mark 页面数据初始化

- (void)addBaseView {
    self.view.backgroundColor=[UIColor backgroundGrayColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    //显示金额父视图
    _purchaseMoneyBaseView=[[TopBottomBalckBorderView alloc] init];
    _purchaseMoneyBaseView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_purchaseMoneyBaseView];
    [_purchaseMoneyBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@50);
    }];
    
    UILabel *incomeTimeTextLB=[[UILabel alloc] init];
    [self.view addSubview:incomeTimeTextLB];
    [incomeTimeTextLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
    NSString *incomeTimeText = @"预计产生收益时间：";
    incomeTimeTextLB.text= incomeTimeText;
    [incomeTimeTextLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_purchaseMoneyBaseView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@20);
    }];
    
    //预计产生收益时间
    _incomeTimeLB = [[UILabel alloc] init];
    [self.view addSubview:_incomeTimeLB];
    _incomeTimeLB.text=@"----";
    [_incomeTimeLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor zheJiangBusinessRedColor]];
    [_incomeTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_purchaseMoneyBaseView.mas_bottom).offset(10);
        make.left.equalTo(incomeTimeTextLB.mas_right);
        make.width.equalTo(@110);
        make.height.equalTo(@20);
    }];
    
    
    //预计产生收益文字
    UILabel *incomeTextLB = [[UILabel alloc] init];
    [self.view addSubview:incomeTextLB];
    [incomeTextLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
    NSString *incomeText=@"预计产生收益：";
    incomeTextLB.text = incomeText;
    CGSize incomeTextWidth = [StringHelper  achieveStrRuleSizeWith:CGSizeMake(CGRectGetWidth(self.view.frame), 30) targetStr:incomeText strFont:14];
    [incomeTextLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_purchaseMoneyBaseView.mas_bottom).offset(35);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.width.equalTo(@(incomeTextWidth.width));
        make.height.equalTo(@20);
    }];
    
    //预计产生收益
    _incomeLB=[[UILabel alloc] init];
    [self.view addSubview:_incomeLB];
    _incomeLB.text=@"----";
    [_incomeLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor zheJiangBusinessRedColor]];
    [_incomeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_purchaseMoneyBaseView.mas_bottom).offset(35);
        make.left.equalTo(incomeTextLB.mas_right);
        make.width.equalTo(@110);
        make.height.equalTo(@20);
    }];
    
    //可用余额展示父视图
    _chooseBankCardBaseView = [[TopBottomBalckBorderView alloc] init];
    _chooseBankCardBaseView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_chooseBankCardBaseView];
    [_chooseBankCardBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_purchaseMoneyBaseView.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@50);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UILabel *bankCardTitleLB=[[UILabel alloc] init];
    [_chooseBankCardBaseView addSubview:bankCardTitleLB];
    bankCardTitleLB.text=@"可用资产";
    [bankCardTitleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
    [bankCardTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.centerY.equalTo(_chooseBankCardBaseView.mas_centerY);
        make.left.equalTo(_chooseBankCardBaseView.mas_left).offset(15);
        make.width.equalTo(@70);
    }];
    
    //显示当前可用余额
    _bankCardLB = [[UILabel alloc] init];
    [_chooseBankCardBaseView addSubview:_bankCardLB];
    _bankCardLB.numberOfLines = 0;
    [_bankCardLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor zheJiangBusinessRedColor]];
    [_bankCardLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.centerY.equalTo(_chooseBankCardBaseView.mas_centerY);
        make.left.equalTo(_chooseBankCardBaseView.mas_left).offset(110);
        make.right.equalTo(_chooseBankCardBaseView.mas_right).offset(-90);
    }];
    
    _rechargeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chooseBankCardBaseView addSubview:_rechargeBT];
    [_rechargeBT setTitle:@"立即充值" forState:UIControlStateNormal];
    _rechargeBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rechargeBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    [_rechargeBT addTarget:self action:@selector(handleRechageBT:) forControlEvents:UIControlEventTouchUpInside];
    [_rechargeBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.centerY.equalTo(_chooseBankCardBaseView.mas_centerY);
        make.width.equalTo(@110);
        make.right.equalTo(_chooseBankCardBaseView.mas_right);
    }];
    _rechargeBT.hidden = YES;
    
    _commitBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_commitBT];
    _commitBT.backgroundColor=[UIColor typefaceGrayColor];
    [FastAnimationAdd codeBindAnimation:_commitBT];
    _commitBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [_commitBT setTitle:@"提交" forState:UIControlStateNormal];
    [_commitBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitBT addTarget:self action:@selector(buyProduct:) forControlEvents:UIControlEventTouchUpInside];
    [_commitBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_chooseBankCardBaseView.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_left).offset(45);
        make.right.equalTo(self.view.mas_right).offset(-45);
        make.height.equalTo(@45);
    }];
}

- (void)handleRechageBT:(UIButton *)sender
{
    [MobClick event:@"buy_page_click_recharge_btn"];
    RechargeVC *rechargeVC = [[RechargeVC alloc] init];
    rechargeVC.fromStr = @"buy";
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)accessFirstVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//当前红包使用的id
- (NSString *)caculateCurrentRebateId {
    NSString *userRebateId = @"0";
    if (self.currentUseRebateModel) {
        if ([self.currentUseRebateModel.cumulative integerValue] != 2) {
            userRebateId = self.currentUseRebateModel.couponId;
        }else {
            userRebateId = @"0";
        }
    }
    return userRebateId;
}

@end

