//
//  BackRebateActivityModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BackRebateActivityModel.h"

@implementation BackRebateActivityModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"type":@"type",@"title":@"title",@"remark":@"remark",@"full":@"full",@"back":@"back",@"increaseDays":@"increaseDays"};
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)increaseDaysJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}
@end
