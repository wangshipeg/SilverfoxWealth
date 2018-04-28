//
//  WidgetManager.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/11/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WidgetManager : NSObject

+ (void)saveWidgetData:(NSArray *)data;
- (NSArray *)getWidgetData;

@end
