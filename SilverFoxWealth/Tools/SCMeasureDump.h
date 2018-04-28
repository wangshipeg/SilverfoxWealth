
//
//  SCMeasure.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndividualInfoManage.h"
#import "SilverWealthProductDetailModel.h"

#define SHARE_SCMEASUREDUMP ([SCMeasureDump shareSCMeasureDump])

@interface SCMeasureDump : NSObject

+ (instancetype)shareSCMeasureDump;

- (void)achieveSignStringWith:(void(^)(NSString *resultStr))callBack;
//注册例外
- (void)achieveSignRegStringWith:(void(^)(NSString *resultStr))callBack;



@property(nonatomic , strong)NSString *mansger;
@property(nonatomic , strong)NSString *codeStyle;
@property (nonatomic, strong) NSString *dataStr;

@property (nonatomic , strong)NSString *productHD;
@property (nonatomic , strong)NSString *productHDTwo;
@property (nonatomic , strong)NSString *productHDThree;

@property (nonatomic , strong)NSString *productHW;
@property (nonatomic , strong)NSString *totleResult;//体验型产品 当前购买金额
@property (nonatomic, strong) NSString *tesult;

@property (nonatomic, strong) NSString *sonID;
@property (nonatomic, strong) NSString *sonName;

@property (nonatomic, strong) SilverWealthProductDetailModel *baobaoModel;

@property (nonatomic, strong) NSString *productListId;

@property (nonatomic, strong) NSString *silverGoodsImageBack;

@property (nonatomic, strong) NSString *accessTokenStr;//大转盘页面accessToken

@property (nonatomic, strong) IndividualInfoManage *userOfObj;

@property (nonatomic, strong) NSString *bankNameAndID;//从添加银行卡界面传值给转出界面
@property (nonatomic, strong) NSString *bankNameId;//从选择银行卡界面传值给转出界面
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *portion;//份数
@property (nonatomic, strong) NSString *sonProductId;

@property (nonatomic, strong) NSString *sureMoney;
@property (nonatomic, strong) NSString *bank;
@property (nonatomic, strong) NSString *moneyRollOut;
@property (nonatomic, strong) NSString  *freeAmountStr;
@property (nonatomic, strong) NSString *thisMonthRollOut;

@property (nonatomic, strong) NSString *nowTime;
@property (nonatomic, strong) NSString *currentTime;
@property (nonatomic, strong) NSString *rebatePages;
@property (nonatomic, strong) NSString *recordPages;
@property (nonatomic, strong) NSString *totalRebate;
@property (nonatomic, strong) NSString *dateActivity;
@property (nonatomic, strong) NSString *myMessagePages;
@property (nonatomic, strong) NSString *socketProductIdAndOrderNOStr;
@property (nonatomic, assign) BOOL isRead;


@property (nonatomic, assign) BOOL isCustomer;
@property (nonatomic, strong) NSString *detailRecordPages;

@property (nonatomic, strong) NSString *webProductId;

@property (nonatomic, strong) NSString *openAccountPresentVC;
@property (nonatomic, strong) NSString *signString;
@property (nonatomic, strong) NSMutableArray *backRebateArray;

@end
