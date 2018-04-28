//
//  SilverWealthProductModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SilverWealthProductModel.h"


@implementation SilverWealthProductModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"productId":@"id",@"name":@"name",@"yearIncome":@"yearIncome",@"increaseInterest":@"increaseInterest",@"property":@"property",@"label":@"label",@"actualAmount":@"actualAmount",@"totalAmount":@"totalAmount",@"interestDate":@"interestDate",@"shippedTime":@"shippedTime",@"financePeriod":@"financePeriod",@"interestType":@"interestType",@"lowestMoney":@"lowestMoney",@"lastOrder":@"lastOrder",@"cashType":@"cashType"};
}

+ (NSValueTransformer *)lastOrderJSONTransformer {
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

+ (NSValueTransformer *)lowestMoneyJSONTransformer {
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

//产品id  格式转换
+ (NSValueTransformer *)increaseInterestJSONTransformer {
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


//category==__NSCFDictionary
//rebate==__NSCFDictionary






















@end
