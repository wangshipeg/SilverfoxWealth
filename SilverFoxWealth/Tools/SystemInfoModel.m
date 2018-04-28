//
//  SystemInfoModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/8/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SystemInfoModel.h"

@implementation SystemInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"idStr":@"id",@"title":@"title",@"createTime":@"createTime",@"type":@"content.type",@"link":@"content.link",@"newsId":@"content.id",@"status":@"status",@"shareDesc":@"shareDesc"};
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

+ (NSValueTransformer *)newsIdJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)createTimeJSONTransformer {
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

//@property (nonatomic, strong) NSString *type;    //新闻类型，1：内部上传，2：外部链接
//@property (nonatomic, strong) NSString *link;    //外部链接 如果是外部链接 打开这个链接





@end

//{
//    content =         {
//        content = "";
//        createTime = 1440399606000;
//        id = 1;
//        link = "www.silverfox-cn.com";
//        newsDate = "2015-08-10";
//        source = "\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00";
//        title = "\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00";
//        type = 2;
//    };
//    createTime = 1440399618000;
//    id = 1;
//    status = 0;
//    title = "\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00\U4e00";
//}
