//
//  VCAppearManager.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "VCAppearManager.h"
#import "SCMeasureDump.h"
#import "MyBonusVC.h"
#import "RechargeVC.h"
#import "DrawalsVC.h"
#import "PersonalAccountVC.h"
#import "SetUpTradePasswordWebView.h"
#import "ResetTradePasswordWebView.h"

@implementation VCAppearManager


// 布置无数据页面
+ (void)arrengmentNotDataViewWithSuperView:(UIView *)superView title:(NSString *)title {
    
    superView.hidden = NO;
    NotDataView *noData = [[NotDataView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    noData.titleLB.text=title;
    noData.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:noData];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[noData]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noData)]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[noData]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(noData)]];
}

//模态出登陆视图AuthorizationAndLoginVC
+ (void)presentLoginVCWithCurrentVC:(UIViewController *)currentVC
{
    AuthorizationAndLoginVC *phoneNumVC = [[AuthorizationAndLoginVC alloc] init];
    UINavigationController *entry=[[UINavigationController alloc] initWithRootViewController:phoneNumVC];
    [currentVC.navigationController presentViewController:entry animated:YES completion:nil];
}

+ (void)presentSetUpTradePasswordVC:(UIViewController *)currentVC
{
    SetUpTradePasswordWebView *setUppasswordVC = [[SetUpTradePasswordWebView alloc] init];
    UINavigationController *entry = [[UINavigationController alloc] initWithRootViewController:setUppasswordVC];
    entry.hidesBottomBarWhenPushed = YES;
    [currentVC presentViewController:entry animated:YES completion:nil];
}

+ (void)presentPersonalAmountCurrentVC:(UIViewController *)currentVC
{
    PersonalAccountVC *rechargeVC = [[PersonalAccountVC alloc] init];
    UINavigationController *entry=[[UINavigationController alloc] initWithRootViewController:rechargeVC];
    [currentVC presentViewController:entry animated:YES completion:nil];
}
/**
 *模态出充值视图
 */
+ (void)presentRechargeVCWithCurrectVC:(UIViewController *)currentVC
{
    RechargeVC *rechargeVC = [[RechargeVC alloc] init];
    UINavigationController *entry=[[UINavigationController alloc] initWithRootViewController:rechargeVC];
    [currentVC presentViewController:entry animated:YES completion:nil];
}

+ (void)presentBindingBankCardVC:(UIViewController *)currentVC
{
    BindingBankCardVC *bindingVC = [[BindingBankCardVC alloc] init];
    UINavigationController *entry = [[UINavigationController alloc] initWithRootViewController:bindingVC];
    [currentVC presentViewController:entry animated:YES completion:nil];
}

/**
 *模态出我的优惠券界面
 */
+ (void)presentMybounsVCWithCurrentVC:(UIViewController *)currentVC
{
    MyBonusVC *phoneNumVC = [[MyBonusVC alloc] init];
    UINavigationController *entry=[[UINavigationController alloc] initWithRootViewController:phoneNumVC];
    [currentVC presentViewController:entry animated:YES completion:nil];
}


//push 出HTML5页面
+ (void)pushH5VCWithCurrentVC:(UIViewController *)currentVC workS:(Work_State)workS
{
    HTMLVC *rebate = [[HTMLVC alloc] init];
    rebate.work = workS;
    rebate.hidesBottomBarWhenPushed = YES;
    [currentVC.navigationController pushViewController:rebate animated:YES];
    if (workS == accountServiceAgreement) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rebate];
        [currentVC presentViewController:nav animated:YES completion:nil];
    }
}

//2.0以后  新的 pushHTML5界面
+ (void)pushNewH5VCWithCurrentVC:(UIViewController *)currentVC workS:(work_net)workS
{
    NewHTMLVC *rebate = [[NewHTMLVC alloc] init];
    rebate.work = workS;
    rebate.hidesBottomBarWhenPushed = YES;
    [currentVC.navigationController pushViewController:rebate animated:YES];
}

//pust 出产品详情页面
+ (void)pushSilverWealthProductDetailWithCurrentVC:(UIViewController *)currentVC model:(NSString *)productId
{
    ProductDetailVC *detailVC = [[ProductDetailVC alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.productId = productId;
    [currentVC.navigationController pushViewController:detailVC animated:YES];
    
//    UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    UINavigationController *VC=(UINavigationController *)control.selectedViewController;
//    UIViewController *productVC=[VC topViewController];
//    [productVC.navigationController pushViewController:detailVC animated:YES];
}

+ (void)presentToResetTraderPasswordCurrentVC:(UIViewController *)currentVC
{
    ResetTradePasswordWebView *resetVC = [[ResetTradePasswordWebView alloc] init];
    UINavigationController *entry=[[UINavigationController alloc] initWithRootViewController:resetVC];
    [currentVC presentViewController:entry animated:YES completion:nil];
}






@end
