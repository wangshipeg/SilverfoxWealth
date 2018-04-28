//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NotDataView.h"
#import "HTMLVC.h"
#import "NewHTMLVC.h"
#import "ProductDetailVC.h"
#import "AuthorizationAndLoginVC.h"
#import "BindingBankCardVC.h"

@interface VCAppearManager : NSObject

/**
 *布置无数据页面
 */
+ (void)arrengmentNotDataViewWithSuperView:(UIView *)superView title:(NSString *)title;


/**
 *模态出登陆视图
 */
+ (void)presentLoginVCWithCurrentVC:(UIViewController *)currentVC;

/**
 *模态出充值视图
 */
+ (void)presentRechargeVCWithCurrectVC:(UIViewController *)currentVC;


/**
 *模态出开户视图
 */
+ (void)presentPersonalAmountCurrentVC:(UIViewController *)currentVC;
/**
 *模态出绑卡界面
 */
+ (void)presentBindingBankCardVC:(UIViewController *)currentVC;

/**
 *模态出我的优惠券界面
 */
+ (void)presentMybounsVCWithCurrentVC:(UIViewController *)currentVC;

/**
 *模态出设置交易密码界面
 */
+ (void)presentSetUpTradePasswordVC:(UIViewController *)currentVC;


/**
 *push 出h5页面
 */
+ (void)pushH5VCWithCurrentVC:(UIViewController *)currentVC workS:(Work_State)workS;
/**
 *2.0版本以后的  push出h5页面
 */
+ (void)pushNewH5VCWithCurrentVC:(UIViewController *)currentVC workS:(work_net)workS;

/**
 *push出 产品详情 页面
 */
+ (void)pushSilverWealthProductDetailWithCurrentVC:(UIViewController *)currentVC model:(NSString *)productId;

/**
 *模态出 修改交易密码界面
 */
+ (void)presentToResetTraderPasswordCurrentVC:(UIViewController *)currentVC;

@end
