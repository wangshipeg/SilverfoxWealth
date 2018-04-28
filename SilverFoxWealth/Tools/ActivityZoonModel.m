//
//  ActivityZoonModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/10/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ActivityZoonModel.h"

@implementation ActivityZoonModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"beginDate":@"beginDate",@"endDate":@"endDate",@"imgUrl":@"imgUrl",@"idStr":@"id",@"shareDesc":@"shareDesc",@"title":@"title",@"content":@"content",@"type":@"type"};
}

+ (NSValueTransformer *)typeJSONTransformer {
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

@end










