//
//  FundProductModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "FundProductModel.h"


@implementation FundProductModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"code":@"code",@"name":@"name",@"type":@"type",@"assetSize":@"assetSize",@"category":@"category",@"endDate":@"endDate",@"fundCompany":@"fundCompany",@"idStr":@"id",@"lowestMoney":@"lowestMoney",@"manager":@"manager",@"yearProfit":@"yearProfit",@"quarterProfit":@"quarterProfit",@"monthProfit":@"monthProfit",@"weekProfit":@"weekProfit",@"net":@"net",@"rebate":@"bonus",@"registerDate":@"registerDate",@"sortNumber":@"sortNumber",@"status":@"status",@"totalNet":@"totalNet",@"venture":@"venture"};
}

//产品id
+ (NSValueTransformer *)idStrJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//资产规模 亿
+ (NSValueTransformer *)assetSizeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//非货币基金为净值 货币基金为万份收益
+ (NSValueTransformer *)netJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//非货币基金为累计净值，货币基金为七日年化收益
+ (NSValueTransformer *)totalNetJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


+ (NSValueTransformer *)yearProfitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)quarterProfitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)monthProfitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)weekProfitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//最低购买金额
+ (NSValueTransformer *)lowestMoneyJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//购买标记  1为正常申购，2暂停申购
+ (NSValueTransformer *)statusJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//排序
+ (NSValueTransformer *)sortNumberJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//产品红包-返利
+ (NSValueTransformer *)rebateJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

//状态
+ (NSValueTransformer *)categoryJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

























@end
