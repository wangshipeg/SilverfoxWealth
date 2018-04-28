//
//  ParseHelper.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

//本类用来解析不同的 从服务器 请求回来的数据
#import <Foundation/Foundation.h>

@interface ParseHelper : NSObject




+(id)parseToUserRebate:(NSData *)responseData;

//解析一般数据为字典
+(id)parseToDic:(NSData *)responseData;



/**
 *解析至 投资客
 */
+(id)parseToCustomer:(NSData *)responseData;

//解析加载错误
+ (NSError *)parseToError:(id)error;


/**
 *解析至 设置交易密码
 */
+(id)parseToSetTradePassword:(NSData *)responseData ;



/**
 *解析银子明细
 */
+(id)parseTosilverClear:(NSData *)responseData;


/**
 *解析 首页banner
 */
+(id)parseToRecommend:(NSData *)responseData;
/**
 *解析 首页产品
 */
+(id)parseToRecommendProduct:(NSData *)responseData;

/**
 *解析至 银狐财富列表数据
 */
+(id)parseToSilverWealthList:(NSData *)responseData;

/**
 *银子商城兑换记录
 */
+ (id)silverTraderExchangeRecord:(NSData *)silverTrader;

/**
 *解析 我的资产
 */
+(id)parseToMyAsset:(NSData *)responseData;

/**
 *解析已购产品 列表
 */
+ (id)parseToAlreadyPurchaseProduct:(NSData *)responseData;
/**
 *解析0元夺宝首页
 */
+ (id)zeroIndianaData:(NSData *)responseData;
/**
 *解析活动专区
 */
+ (id)activityZoonData:(NSData *)responseData;
/**
 *解析我的夺宝记录
 */
+ (id)myIndianaRecordsInfo:(NSData *)responseData;

/**
 *解析赚银子接口
 */
+ (id)earnSilverInfo:(NSData *)responseData;
/**
 *解析已购产品详情
 */
+ (id)parseToAlreadyPurchaseProductDetail:(NSData *)responseData;

/**
 *解析已绑银行卡 列表
 */
+ (id)parseToAlreadyBindBankCardWith:(NSData *)responseData;

/**
 *解析当前支持的银行卡 列表
 */
+ (id)parseToBankSupportListWith:(NSData *)responseData;

/**
 *解析银狐财富产品详情
 */
+ (id)parseToSilverWealthProductDetailWith:(NSData *)responseData;

/**
 *银子商城兑换
 */
+ (id)silverTraderExchangeHH:(NSData *)responseData;

/**
 *解析我的红包
 */
+(id)parseToRebate:(NSData *)responseData;

/**
 *解析本月累计签到天数
 */
+(id)monthSignInTimesList:(NSData *)responseData;
/**
 *解析签到奖励
 */
+(id)monthSignInRewardList:(NSData *)responseData;
/**
 *解析签到奖励领取记录
 */
+(id)monthSignInGetRecordList:(NSData *)responseData;
/**
 *解析奖励列表
 */
+(id)monthSignInPrizeListList:(NSData *)responseData;

/**
 *解析订单号
 */
+ (id)parseToOrderNum:(NSData *)responseData;
/**
 *转出订单解析
 */
+ (id)parseToRollOutOrderNum:(NSData *)responseData;
/**
 *转出银行卡绑定
 */
+ (id)parseToBinDingBankUser:(NSData *)responseData;
/**
 *解析至产品详情页 购买记录
 */
+ (id)parseToSilverWealthProductDetailButBlockUpWith:(NSData *)responseData;

+ (id)parseToSilverWealthProductDetailButBlockUpAWith:(NSData *)responseData;
/**
 *解析用户的消息
 */
+(id)parseToUserMessage:(NSData *)responseData;

/**
 *解析系统消息
 */
+ (id)parseToSystemMessage:(NSData *)responseData;

/**
 *解析至身份证验证字典
 */
+(id)parseToIdCardDic:(NSData *)responseData;


/**
 *解析签到
 */
+(id)parseToUserSign:(NSData *)responseData;

/**
 *解析我的消息 历史数据
 */
+(id)parseToUserHistoryMessageList:(NSData *)responseData;



/**
 *认证
 */
+(NSString *)parseToAuthenticationDic:(NSData *)responseData;


/**
 *授权
 */
+ (id)parseToAuthorizationDic:(NSData *)responseData;

/**
 *解析至 是否已购买某产品
 */
+ (NSString *)parseToWhetherAlreadyBuyProduct:(NSData *)responseData;



//解析至银子商城页面
+ (id)silverTrader:(NSData *)silverData;
+ (id)parseToSilverGoods:(NSData *)responseData;

//解析至启动页页面
+ (id)startPicture:(NSData *)startPic;

//解析至首页弹窗页面
+ (id)parseToRecommendPopup:(NSData *)responseData;


/**
 *解析至理财专栏
 */
+ (id)parseToFinanclalConumnList:(NSData *)responseData;

/**
 *解析至用户上次使用银行卡
 */
+ (id)parseToCustomerLastTimeUseBank:(NSData *)responseData;

/**
 *解析至code
 */
+ (id)parseToCode:(NSData *)responseData;

/**
 *解析至交易明细
 */
+ (id)parseToExchangeDetail:(NSData *)responseData;
/**
 *解析至返利活动
 */
+ (id)parseToRebateAcitvity:(NSData *)responseData;

/**
 *解析至首页悬浮按钮
 */
+ (id)parseToFirstPageButton:(NSData *)responseData;

/**
 *获取补签卡列表
 */
+ (id)parseToRetroactiveCardList:(NSData *)responseData;

@end
