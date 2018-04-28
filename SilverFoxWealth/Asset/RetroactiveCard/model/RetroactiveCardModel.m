//
//  RetroactiveCardModel.m
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RetroactiveCardModel.h"

@implementation RetroactiveCardModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"retroactiveCardId":@"id",@"expireTime":@"expireTime"};
}

+ (NSValueTransformer *)idStrJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num = value;
        return [num stringValue];
    }];
}


@end
