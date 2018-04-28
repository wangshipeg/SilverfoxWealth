//
//  UINavigationController+DetectionNetState.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (DetectionNetState)

//实时检测网络变化  如果没有
- (void)detectionCurrentNetWith:(BOOL)state;

@end
