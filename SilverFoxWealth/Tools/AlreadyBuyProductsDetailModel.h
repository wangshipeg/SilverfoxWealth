//
//  AlreadyBuyProductsDetailModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <Mantle/Mantle.h>
@interface AlreadyBuyProductsDetailModel : MTLModel<MTLJSONSerializing>

/*
 couponCategory
 couponPeriod
 couponAmount
 productName
 orderTime
 financePeriod
 principal
 baseProfit
 productId
 remainingDays
 status
 signature
 interest
 */
@property (nonatomic, strong) NSString *couponCategory;//优惠券类型  1-红包 2-加息券  3未使用
@property (nonatomic, strong) NSString *couponPeriod;//加息天数
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *orderTime;
@property (nonatomic, strong) NSString *financePeriod;
@property (nonatomic, strong) NSString *principal;
@property (nonatomic, strong) NSString *baseProfit;//待收利息
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *remainingDays;
@property (nonatomic, strong) NSString *status; //1售罄 2未售罄 3已回款
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *interest;
@property (nonatomic, strong) NSString *interestDate;
@property (nonatomic, strong) NSString *couponAmount;
@property (nonatomic, strong) NSString *interestType;//1 T+1起息
@property (nonatomic, strong) NSString *vipProfit;
@end
