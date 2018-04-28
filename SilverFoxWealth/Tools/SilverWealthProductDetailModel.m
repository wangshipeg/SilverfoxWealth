//
//  SilverWealthProductDetailModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/3/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SilverWealthProductDetailModel.h"
/*
 name
 lowestMoney
 actualAmount
 totalAmount
 yearIncome
 shippedTime
 label
 versionDiscriminate
 interestDate
 financePeriod
 property
 highestMoney
 increaseInterest
 firstOrder
 lastOrder
 bonusStrategy
 protocols
 */

@implementation SilverWealthProductDetailModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"productId":@"id",@"name":@"name",@"lowestMoney":@"lowestMoney",@"actualAmount":@"actualAmount",@"totalAmount":@"totalAmount",@"yearIncome":@"yearIncome",@"shippedTime":@"shippedTime",@"versionDiscriminate":@"versionDiscriminate",@"interestDate":@"interestDate",@"financePeriod":@"financePeriod",@"property":@"property",@"highestMoney":@"highestMoney",@"increaseInterest":@"increaseInterest",@"firstOrder":@"firstOrder",@"lastOrder":@"lastOrder",@"bonusStrategy":@"bonusStrategy",@"protocols":@"protocols",@"label":@"label",@"interestType":@"interestType",@"existContract":@"existContract",@"cashType":@"cashType",@"cashAmount":@"cashAmount"};
}

+ (NSValueTransformer *)cashAmountJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)cashTypeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


+ (NSValueTransformer *)existContractJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


+ (NSValueTransformer *)interestTypeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)lastOrderJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)yearIncomeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//产品id  格式转换
+ (NSValueTransformer *)productIdJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//理财期限 格式转换
+ (NSValueTransformer *)financePeriodJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


//总共购买次数 格式转换
+ (NSValueTransformer *)lowestMoneyJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//总计购买金额
+ (NSValueTransformer *)totalAmountJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//总计购买金额
+ (NSValueTransformer *)actualAmountJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//购买上限
+ (NSValueTransformer *)highestMoneyJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


//购买上限
+ (NSValueTransformer *)increaseInterestJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


//返利类型
+ (NSValueTransformer *)versionDiscriminateJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


//category==__NSCFDictionary
//rebate==__NSCFDictionary

@end
