//
//  WithoutAuthorization.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WithoutAuthorization.h"

@implementation WithoutAuthorization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"code":@"code",@"error_msg":@"msg"};
}

+ (NSValueTransformer *)codeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

@end
