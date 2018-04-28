//
//  RechargeVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RechargeVC.h"
#import "QuickPaymentVC.h"
#import "BankCardPaymentVC.h"
#import "VCAppearManager.h"
#import "DataRequest.h"
#import "BankAndIdentityInfoModel.h"
#import "StringHelper.h"

@interface RechargeVC ()
@property (nonatomic, strong) BankAndIdentityInfoModel *bankModel;
@property (nonatomic, strong) QuickPaymentVC *quickVC;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation RechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"充值";
    self.title = @"充值";
    [_customNav.rightButton setTitle:@"限额说明" forState:UIControlStateNormal];
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _customNav.rightButtonHandle = ^{
        [MobClick event:@"recharge_click_money_limit"];
        [VCAppearManager pushH5VCWithCurrentVC:weakSelf workS:limitInfo];
    };
    _quickVC = [[QuickPaymentVC alloc] init];
    _quickVC.fromStr = _fromStr;
    BankCardPaymentVC *bankVC = [[BankCardPaymentVC alloc] init];
    self.titleArray = @[@"快捷支付",@"银行转账"];
    self.controllerArray = @[_quickVC,bankVC];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self requestBankLimitWithData];
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
}

- (void)requestBankLimitWithData
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] obtainUserAlreadyBindCardListWithcustomerId:user.customerId channel:@"000001" callback:^(id obj) {
        [SVProgressHUD dismiss];
        DLog(@"充值页面银行卡======%@",obj);
        if ([obj isKindOfClass:[BankAndIdentityInfoModel class]]) {
            _bankModel = obj;
            NSString *bankNumberStr=[_bankModel.cardNO substringWithRange:NSMakeRange(_bankModel.cardNO.length-4, 4)];
            NSString *singleStr = nil;
            NSString *everyDayStr = nil;
            if ([_bankModel.singleLimit intValue] < 10000) {
                singleStr = [NSString stringWithFormat:@"%@元",_bankModel.singleLimit];
            }else{
                singleStr = [NSString stringWithFormat:@"%d万",[_bankModel.singleLimit intValue] / 10000];
            }
            if ([_bankModel.dayLimit intValue] < 10000) {
                everyDayStr = [NSString stringWithFormat:@"%@元",_bankModel.dayLimit];
            }else{
                everyDayStr = [NSString stringWithFormat:@"%d万",[_bankModel.dayLimit intValue] / 10000];
            }
            NSString *limitSftr = [NSString stringWithFormat:@"单笔%@/单日%@",singleStr,everyDayStr];
            _quickVC.bankLimit = [StringHelper renderFrontAndAfterDifferentFontWithValue:[NSString stringWithFormat:@"%@(尾号%@)\n",_bankModel.bankName,bankNumberStr] frontFont:14 frontColor:[UIColor iconBlueColor] afterStr:limitSftr afterFont:13 afterColor:[UIColor depictBorderGrayColor]];
        }
        [self sendMessageToRechargeDataRequest];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

- (void)sendMessageToRechargeDataRequest{
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"rechargeShow" object:Nil userInfo:nil];
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

