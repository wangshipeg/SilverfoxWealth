//
//  FinancialColumnModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FinancialColumnModel.h"


@implementation FinancialColumnModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"title":@"title",@"type":@"type",@"imageUrl":@"imageUrl",@"outLink":@"outLink",@"idStr":@"financeNewsId",@"remark":@"remark",@"shareDesc":@"shareDesc"};
}

//+ (NSValueTransformer *)idStrJSONTransformer {
//    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        NSNumber *num=value;
//        return [num stringValue];
//    }];
//}

//+ (NSValueTransformer *)typeJSONTransformer {
//    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        NSNumber *num=value;
//        return [num stringValue];
//    }];
//}

@end
