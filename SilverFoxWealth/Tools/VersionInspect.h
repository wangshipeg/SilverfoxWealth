//
//  VersionInspect.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppleVersionModel.h"

@interface VersionInspect : NSObject

/**
 *从苹果获取版本信息
 */
+ (void)achieveVersionFromAppleWithCallback:(void(^)(AppleVersionModel *versionModel))callback;

/**
 *app需要更新 isUpdate为是否强制更新  updateContent为更新内容
 */
+ (void)whetherUpdateWith:(BOOL)isUpdate updateContent:(NSString *)updateContent;

/**
 *如果更新结束  进入app时提示视图还在 就清除
 */
+ (void)updateFinish;


@end
