//
//  PopupModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/10/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PopupModel.h"


@implementation PopupModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"amount":@"amount",@"idStr":@"id",@"condition":@"condition",@"category":@"category"};
}

+ (NSValueTransformer *)amountJSONTransformer {
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
+ (NSValueTransformer *)categoryJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

@end
