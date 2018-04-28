//
//  SilverWealthProductModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

//银狐财富 单个产品model

#import "MTLModel.h"
#import <Mantle/Mantle.h>

//银狐财富 产品数据模型
@interface SilverWealthProductModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, strong) NSString  *productId;     //产品id
@property (nonatomic, strong) NSString  *name;          //产品名称
@property (nonatomic, strong) NSString  *yearIncome;    //预期年化收益
@property (nonatomic, strong) NSString  *increaseInterest; //加息
@property (nonatomic, strong) NSString  *property;
@property (nonatomic , strong)NSString  *label;//活动说明
@property (nonatomic, strong) NSString  *actualAmount;  //实际募捐金额
@property (nonatomic, strong) NSString  *totalAmount;   //募集总金额
@property (nonatomic, strong) NSString  *interestDate;  //起息时间
@property (nonatomic, strong) NSString  *financePeriod; //理财期限
@property (nonatomic, strong) NSString  *shippedTime;   //上架时间
@property (nonatomic, strong) NSString *interestType; //0-固定起息 1-T+1起息 2-购买当天起息
@property (nonatomic, strong) NSString *lowestMoney;
@property (nonatomic, strong) NSString *lastOrder;
@property (nonatomic, strong) NSString *cashType;
@end
