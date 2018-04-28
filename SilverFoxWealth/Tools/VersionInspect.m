//
//  VersionInspect.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "VersionInspect.h"
#import <AFHTTPSessionManager.h>
#import "VersionNoteView.h"
#import "VersionNoteBaseView.h"

@implementation VersionInspect

+ (void)achieveVersionFromAppleWithCallback:(void(^)(AppleVersionModel *versionModel))callback {
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    NSString *ur = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=1008067568&country=%@",countryCode];
    AFHTTPSessionManager *manger=[AFHTTPSessionManager  manager];
    [manger GET:ur parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"responseObject==%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=responseObject;
            NSArray *resultArray=dic[@"results"];
            NSDictionary *resultDic=[resultArray objectAtIndex:0];
            NSError *error=nil;
            AppleVersionModel *model=[MTLJSONAdapter modelOfClass:[AppleVersionModel class] fromJSONDictionary:resultDic error:&error];
            if (error) {
                callback(nil);
                return;
            }
            callback(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(nil);
    }];
}

+ (void)whetherUpdateWith:(BOOL)isUpdate updateContent:(NSString *)updateContent {
    
    VersionNoteView *noteView = [[VersionNoteView alloc] initWithFrame:CGRectMake(0, 0, 400, 165) forceUpdate:isUpdate];
    
    //如果屏幕上有提示视图就不再添加了
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[VersionNoteBaseView class]]) {
            noteView=nil;
            return;
        }
    }
    noteView.textView.text=updateContent;
    [noteView  showWithUpdateBlock:^{
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yin-hu-cai-fu/id1008067568?mt=8&uo=4"];
        [[UIApplication sharedApplication]openURL:url];
    }];
    
}

//如果更新结束  进入app时提示视图还在 就清除
+ (void)updateFinish {
    //如果屏幕上有提示视图就不再添加了
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[VersionNoteBaseView class]]) {
            [view removeFromSuperview];
            return;
        }
    }
}




















@end
