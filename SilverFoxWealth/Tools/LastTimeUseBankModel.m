//
//  LastTimeUseBankModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/3/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LastTimeUseBankModel.h"

@implementation LastTimeUseBankModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"singleLimit":@"bankLimit.singleLimit",@"dayLimit":@"bankLimit.dayLimit",@"monthLimit":@"bankLimit.monthLimit",@"bankName":@"defaultBank.bankName",@"cardNO":@"defaultBank.cardNO",@"bankNO":@"defaultBank.bankNO",@"status":@"defaultBank.status"};
}

+ (NSValueTransformer *)statusJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


+ (NSValueTransformer *)monthLimitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)dayLimitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)singleLimitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}
@end
