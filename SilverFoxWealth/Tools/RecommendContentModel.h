//
//  RecommendContentModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface RecommendContentModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString  *yearIncome; //基础年化收益
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *increaseInterest;//加息额度

@property (nonatomic, strong) NSString  *productId;
@property (nonatomic, strong) NSString  *property;// 产品类型

@property (nonatomic, strong) NSString  *financePeriod;// 理财期限
@property (nonatomic, strong) NSString  *rebateName;// 活动名称
@property (nonatomic, strong) NSString *label;// 产品标签
@property (nonatomic, strong) NSString *shippedTime;//上架时间

@property (nonatomic, strong) NSString *interestDate;//起息时间

@property (nonatomic, strong) NSArray *bonusStrategy;//年化收益阶梯

@property (nonatomic, strong) NSString  *actualAmount;  //实际募捐金额
@property (nonatomic, strong) NSString  *totalAmount;   //募集总金额

@property (nonatomic, strong) NSString *url;
@end
