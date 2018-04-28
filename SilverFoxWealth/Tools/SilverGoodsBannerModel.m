//
//  SilverGoodsBannerModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/7/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SilverGoodsBannerModel.h"

@implementation SilverGoodsBannerModel
//前面是model中的属性名  后面的是json中的key
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"link":@"link",@"category":@"category",@"idStr":@"id",@"url":@"url"};
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
