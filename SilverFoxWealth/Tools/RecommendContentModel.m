//
//  RecommendContentModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RecommendContentModel.h"

@implementation RecommendContentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"yearIncome":@"yearIncome",@"name":@"name",@"productId":@"id",@"financePeriod":@"financePeriod",@"increaseInterest":@"increaseInterest",@"label":@"label",@"bonusStrategy":@"bonus.bonusStrategy",@"property":@"property",@"shippedTime":@"shippedTime",@"interestDate":@"interestDate",@"actualAmount":@"actualAmount",@"totalAmount":@"totalAmount",@"url":@"url"};
}

//+ (NSValueTransformer *)interestDateJSONTransformer {
//    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        NSNumber *num=value;
//        return [num stringValue];
//    }];
//}


+ (NSValueTransformer *)shippedTimeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}




+ (NSValueTransformer *)totalAmountJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)increaseInterestJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)actualAmountJSONTransformer {
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

+ (NSValueTransformer *)productIdJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}
+ (NSValueTransformer *)financePeriodJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


@end





