//
//  VersionInfoModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/8/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "VersionInfoModel.h"

@implementation VersionInfoModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"idStr":@"id",@"versionNumber":@"version",@"upgradeContent":@"content",@"status":@"status",@"url":@"url",@"upgradeType":@"type"};
}

@end
