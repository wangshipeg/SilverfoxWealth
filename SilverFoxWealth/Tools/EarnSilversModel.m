//
//  EarnSilversModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EarnSilversModel.h"

@implementation EarnSilversModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"address":@"address",@"name":@"name",@"type":@"type",@"content":@"content",@"idStr":@"id",@"shareContent":@"shareContent",@"shareTitle":@"news.title",@"shareType":@"newsType",@"outLink":@"outLink",@"shareId":@"newsId"};
}
+ (NSValueTransformer *)shareIdJSONTransformer {
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

+ (NSValueTransformer *)typeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

@end
