//
//  IndianaRecordsModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "IndianaRecordsModel.h"

@implementation IndianaRecordsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"cellphone":@"cellphone",@"createTime":@"createTime",@"joinCode":@"joinCode"};
}

+ (NSValueTransformer *)joinCodeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


@end
