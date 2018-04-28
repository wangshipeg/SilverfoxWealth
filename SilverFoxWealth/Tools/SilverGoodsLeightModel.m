//
//  SilverGoodsLeightModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SilverGoodsLeightModel.h"

@implementation SilverGoodsLeightModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name":@"name",@"cellphone":@"cellphone"};
}

//+ (NSValueTransformer *)cellphoneJSONTransformer {
//    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        NSNumber *num=value;
//        return [num stringValue];
//    }];
//}


@end
