//
//  RechargeAndDrawalsSuccessVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/7/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RechargeAndDrawalsSuccessVC.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "ExchangeDetailVC.h"
#import "CommitBuyInfoWebview.h"

@interface RechargeAndDrawalsSuccessVC ()
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation RechargeAndDrawalsSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"充值成功";
    self.title = @"充值成功";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        if ([weakSelf.fromStr isEqualToString:@"asset"]) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            UIViewController *target = nil;
            for (UIViewController * controller in weakSelf.navigationController.viewControllers) {
                if ([controller isKindOfClass:[CommitBuyInfoWebview class]]) {
                    target = controller;
                }
            }
            if (target) {
                [weakSelf.navigationController popToViewController:target animated:YES];
            }
        }
    };
    [self UIDecorate];
    // Do any additional setup after loading the view.
}

- (void)UIDecorate
{
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SuccessLogo.png"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.customNav.mas_bottom).offset(40);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    UILabel *successLB = [[UILabel alloc] init];
    successLB.text = @"充值成功";
    successLB.textAlignment = NSTextAlignmentCenter;
    successLB.font = [UIFont systemFontOfSize:14];
    successLB.textColor = [UIColor zheJiangBusinessRedColor];
    [self.view addSubview:successLB];
    [successLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    
    UILabel *contentLB = [[UILabel alloc] init];
    contentLB.text = [NSString stringWithFormat:@"本次充值%.2f元",[_amountStr doubleValue]];
    contentLB.textAlignment = NSTextAlignmentCenter;
    contentLB.font = [UIFont systemFontOfSize:16];
    contentLB.textColor = [UIColor characterBlackColor];
    [self.view addSubview:contentLB];
    [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(successLB.mas_bottom).offset(30);
        make.width.equalTo(@300);
        make.height.equalTo(@20);
    }];
    
    RoundCornerClickBT *_nextBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_nextBT setTitle:@"查看资产" forState:UIControlStateNormal];
    _nextBT.titleLabel.font = [UIFont systemFontOfSize:16];
    _nextBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
    [_nextBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBT addTarget:self action:@selector(accessFirstVC:) forControlEvents:UIControlEventTouchUpInside];
    [FastAnimationAdd codeBindAnimation:_nextBT];
    [self.view addSubview:_nextBT];
    [_nextBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLB.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
        make.height.equalTo(@45);
    }];
    
    RoundCornerClickBT *backDetailBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [backDetailBT setTitle:@"充值记录" forState:UIControlStateNormal];
    backDetailBT.titleLabel.font = [UIFont systemFontOfSize:16];
    backDetailBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
    [backDetailBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backDetailBT addTarget:self action:@selector(clickBackChangeDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    [FastAnimationAdd codeBindAnimation:backDetailBT];
    [self.view addSubview:backDetailBT];
    [backDetailBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nextBT.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
        make.height.equalTo(@45);
    }];
}

- (void)clickBackChangeDetailVC:(RoundCornerClickBT *)sender
{
    ExchangeDetailVC *exchangVC = [[ExchangeDetailVC alloc] init];
    exchangVC.whereFrom = @"1";
    [self.navigationController pushViewController:exchangVC animated:YES];
}

- (void)accessFirstVC:(RoundCornerClickBT *)sender
{
    if ([_fromStr isEqualToString:@"asset"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        [control setSelectedIndex:3];
    }
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

