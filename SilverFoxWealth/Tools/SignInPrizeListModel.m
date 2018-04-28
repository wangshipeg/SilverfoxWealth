//
//  SignInPrizeListModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SignInPrizeListModel.h"

@implementation SignInPrizeListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"answerA":@"answerA",@"answerB":@"answerB",@"answerC":@"answerC",@"answerD":@"answerD",@"days":@"days",@"giveNum":@"giveNum",@"idStr":@"id",@"giveType":@"giveType",@"question":@"question",@"rightAnswer":@"rightAnswer"};
}
+ (NSValueTransformer *)idStrJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}
+ (NSValueTransformer *)daysJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}
+ (NSValueTransformer *)giveNumJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}
+ (NSValueTransformer *)giveTypeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}+ (NSValueTransformer *)rightAnswerJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

@end









