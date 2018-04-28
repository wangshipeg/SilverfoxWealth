//
//  SupportBankModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SupportBankModel.h"

@implementation SupportBankModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"cardType":@"cardType",@"bankId":@"id",@"bankName":@"name",@"remark":@"remark",@"serialNO":@"serialNO",@"enable":@"enable"};
}

+ (NSValueTransformer *)enableJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)bankIdJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}



@end
