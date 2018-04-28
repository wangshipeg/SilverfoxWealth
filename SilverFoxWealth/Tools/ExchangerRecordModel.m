//
//  ExchangerRecordModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ExchangerRecordModel.h"
/**
 imgUrl:”图片地址”
 goodsName：“天堂伞”
 type:1//1:虚拟商品2：实物商品3：第三方券码
 exchangeTime:”yyyy-MM-dd hh:mm:ss”
 thirdPartyNO:”UXJKSJKLS”
 cost:100
 */
@implementation ExchangerRecordModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"url":@"url",@"goodsName":@"goodsName",@"cost":@"cost",@"exchangeTime":@"exchangeTime",@"thirdPartyNO":@"thirdPartyNO",@"type":@"type"};
}

+ (NSValueTransformer *)costJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

@end








