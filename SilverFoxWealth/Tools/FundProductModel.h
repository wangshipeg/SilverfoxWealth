//
//  FundProductModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface FundProductModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *code; //基金代码
@property (nonatomic, strong) NSString *name; //基金名称
@property (nonatomic, strong) NSString *type; //基金类型
@property (nonatomic, strong) NSString *assetSize; //资产规模 亿
@property (nonatomic, strong) NSString *category; //状态 0
@property (nonatomic, strong) NSString *endDate; //日期
@property (nonatomic, strong) NSString *fundCompany; //基金公司
@property (nonatomic, strong) NSString *idStr;  //对应的是id
@property (nonatomic, strong) NSString *lowestMoney; //最低购买金额
@property (nonatomic, strong) NSString *manager; //基金经理

@property (nonatomic, strong) NSString *yearProfit;
@property (nonatomic, strong) NSString *quarterProfit;
@property (nonatomic, strong) NSString *monthProfit;
@property (nonatomic, strong) NSString *weekProfit;

@property (nonatomic, strong) NSString *net; //非货币基金为净值 货币基金为买一万份的收益
@property (nonatomic, strong) NSString *rebate; //产品红包-返利
@property (nonatomic, strong) NSString *registerDate; //成立日期
@property (nonatomic, strong) NSString *sortNumber; //排序
@property (nonatomic, strong) NSString *status; //购买标记  1为正常申购，2暂停申购
@property (nonatomic, strong) NSString *totalNet; //非货币基金为累计净值，货币基金为七日年化收益
@property (nonatomic, strong) NSString *venture; //投资风险特性



@end
