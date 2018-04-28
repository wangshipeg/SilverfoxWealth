//
//  PathHelper.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PathHelper.h"

@implementation PathHelper

+(BOOL)createPathIfNecessary:(NSString *)path{
    BOOL succeeded = YES;
    NSFileManager *fm=[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        succeeded=[fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return succeeded;
}

//往document盘下面创建名字为name的文件夹 然后返回路径
+(NSString *)documentDirectoryPathWithName:(NSString *)name{
    NSArray *pahts=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *cachesPath=[pahts objectAtIndex:0];
    NSString *cachePath=[cachesPath stringByAppendingPathComponent:name];
    [PathHelper createPathIfNecessary:cachesPath];
    [PathHelper createPathIfNecessary:cachePath];
    return cachePath;
}


//往临时文件夹下创建名字为name的文件夹 并返回路径
+(NSString *)cacheDirectoryPathWithName:(NSString *)name{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath=[paths objectAtIndex:0];
    NSString *cachePath=[cachesPath stringByAppendingPathComponent:name];
    [PathHelper createPathIfNecessary:cachesPath];
    [PathHelper createPathIfNecessary:cachePath];
    return cachePath;
}

























@end
