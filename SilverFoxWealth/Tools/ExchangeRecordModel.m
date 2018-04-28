//
//  ExchangeRecordModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ExchangeRecordModel.h"
/*
 "amount": 100,
 "purpose": "到期回款-榜单活动60",
 "tradeTime": "2017-06-01 00:00:00",
 */

@implementation ExchangeRecordModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"amount":@"amount",@"purpose":@"purpose",@"tradeTime":@"tradeTime"};
}

+ (NSValueTransformer *)amountJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

@end
