//
//  SilverWealthProductDetailModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/3/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface SilverWealthProductDetailModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString  *productId;     //产品id
@property (nonatomic, strong) NSString  *name;          //产品名称
@property (nonatomic, strong) NSString  *lowestMoney;   //起投金额
@property (nonatomic, strong) NSString  *actualAmount;  //实际募捐金额
@property (nonatomic, strong) NSString  *totalAmount;   //募集总金额
@property (nonatomic, strong) NSString  *yearIncome;    //预期年化收益
@property (nonatomic, strong) NSString  *shippedTime;   //上架时间
@property (nonatomic , strong)NSString  *label;//活动说明
@property (nonatomic, strong) NSString *versionDiscriminate;//版本
@property (nonatomic, strong) NSString  *interestDate;  //起息时间
@property (nonatomic, strong) NSString  *financePeriod; //理财期限
@property (nonatomic, strong) NSString  *property;
@property (nonatomic, strong) NSString  *highestMoney;   //购买上限
@property (nonatomic, strong) NSString  *increaseInterest; //加息
@property (nonatomic, strong) NSString *firstOrder;//首单
@property (nonatomic, strong) NSString *lastOrder;//尾单
@property (nonatomic, strong) NSString *bonusStrategy;
@property (nonatomic, strong) NSString *protocols;
@property (nonatomic, strong) NSString *interestType;//1 T+1起息
@property (nonatomic, strong) NSString *existContract;//0不存在
@property (nonatomic, strong) NSString *cashType;//尾单返利 1-固定现金 2-投资金额百分比现金
@property (nonatomic, strong) NSString *cashAmount;


@end
