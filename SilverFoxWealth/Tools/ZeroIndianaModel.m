//
//  ZeroIndianaModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZeroIndianaModel.h"

@implementation ZeroIndianaModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"goodsName":@"name",@"url":@"url",@"stock":@"stock",@"joinNum":@"joinNum",@"idStr":@"id",@"consumeSilver":@"consumeSilver"};
}

+ (NSValueTransformer *)consumeSilverJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)idStrJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


+ (NSValueTransformer *)stockJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)joinNumJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

@end
