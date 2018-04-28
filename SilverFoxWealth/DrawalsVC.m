//
//  DrawalsVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DrawalsVC.h"
#import "LargeAmountDrawalsVC.h"
#import "QuickDrawalsVC.h"
#import "DataRequest.h"
#import <SVProgressHUD.h>
#import "BankAndIdentityInfoModel.h"

@interface DrawalsVC ()
@property (nonatomic, strong) BankAndIdentityInfoModel *bankModel;
@property (nonatomic, strong) QuickDrawalsVC *quickVC;
@property (nonatomic, strong) LargeAmountDrawalsVC *bankVC;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation DrawalsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"提现";
    self.title = @"提现";
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _quickVC = [[QuickDrawalsVC alloc] init];
    _bankVC = [[LargeAmountDrawalsVC alloc] init];
    self.titleArray = @[@"快速提现",@"大额提现"];
    self.controllerArray = @[_quickVC,_bankVC];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestBankInfoData];
}

- (void) requestBankInfoData
{
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 5;
    NSBlockOperation *operationA = [NSBlockOperation blockOperationWithBlock:^{
        [[DataRequest sharedClient]requestUserBalanceAmountWithCustomerId:user.customerId channel:@"000001" callback:^(id obj) {
            DLog(@"可用资产=======%@",obj);
            if ([obj isKindOfClass:[NSDictionary class]]) {
                _quickVC.balanceStr = obj[@"balance"];
                _bankVC.balanceStr = obj[@"balance"];
            }
        }];
    }];
    NSBlockOperation *operationB = [NSBlockOperation blockOperationWithBlock:^{
        [[DataRequest sharedClient] obtainUserAlreadyBindCardListWithcustomerId:user.customerId channel:@"000001" callback:^(id obj) {
            [SVProgressHUD dismiss];
            DLog(@"提现银行卡======%@",obj);
            if ([obj isKindOfClass:[BankAndIdentityInfoModel class]]) {
                _bankModel = obj;
                NSString *bankNumberStr=[_bankModel.cardNO substringWithRange:NSMakeRange(_bankModel.cardNO.length-4, 4)];
                _quickVC.bankInfoStr = [NSString stringWithFormat:@"%@(尾号%@)",_bankModel.bankName,bankNumberStr];
                _bankVC.bankInfoStr = [NSString stringWithFormat:@"%@(尾号%@)",_bankModel.bankName,bankNumberStr];
                _quickVC.cardNOStr = _bankModel.cardNO;
                _bankVC.cardNOStr = _bankModel.cardNO;
            }
        }];
    }];
    NSBlockOperation *operationC = [NSBlockOperation blockOperationWithBlock:^{
        [[DataRequest sharedClient]requestFreeTimesWithCustomerId:user.customerId callback:^(id obj) {
            DLog(@"提现次数=====%@",obj);
            if ([obj isKindOfClass:[NSDictionary class]]) {
                _quickVC.freeTimesStr = obj[@"times"];
                _quickVC.totalStr = obj[@"total"];
                _bankVC.freeTimesStr = obj[@"times"];
                _bankVC.totalStr = obj[@"total"];
            }
            if ([obj isKindOfClass:[NSString class]]) {
                [SVProgressHUD showErrorWithStatus:obj];
            }
            [self sendMessageToCouponsListDataRequest];
        }];
    }];
    //排序
    [operationB addDependency:operationA];
    [operationC addDependency:operationB];
    [queue addOperation:operationA];
    [queue addOperation:operationB];
    [queue addOperation:operationC];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}



- (void)sendMessageToCouponsListDataRequest{
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"withrowShow" object:Nil userInfo:nil];
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

