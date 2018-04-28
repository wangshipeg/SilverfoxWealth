//
//  GetSignInRecordModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GetSignInRecordModel.h"

@implementation GetSignInRecordModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"recordIdStr":@"signInPrize.id"};
}
+ (NSValueTransformer *)recordIdStrJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


@end





