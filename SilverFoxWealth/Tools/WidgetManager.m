//
//  WidgetManager.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/11/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WidgetManager.h"

@implementation WidgetManager

static NSString *const GroupID = @"group.com.silverfox.wealther";
static NSString *const kWidgetKey = @"dataArrayKey";

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//保存data
+ (void)saveWidgetData:(NSArray *)data
{
    if (data.count > 0) {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:GroupID];
        NSData *widgetData = [NSKeyedArchiver archivedDataWithRootObject:data];
        [userDefaults setObject:widgetData forKey:kWidgetKey];
        //立即写入沙盒
        [userDefaults synchronize];
    }
}

//读取数据
- (NSArray *)getWidgetData
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:GroupID];
    NSData *unWidgetData = [userDefaults objectForKey:kWidgetKey];
    NSArray *allDataArray = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:unWidgetData];
    NSLog(@"allDataArray======%@",allDataArray);
    if (allDataArray.count > 0){
        return allDataArray;
    }
    return [NSMutableArray array];
}

@end




