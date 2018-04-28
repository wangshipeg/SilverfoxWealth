//
//  UserInfoModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/8/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
/*title: 到期回款;
 createTime : 2017-03-13 09:09:09;
 id : 105;
 status : 0;
 message : "亲爱的用户…..";
 */

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"title":@"title",@"createTime":@"createTime",@"idStr":@"id",@"message":@"message",@"status":@"status"};
}
+ (NSValueTransformer *)statusJSONTransformer {
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
