//
//  UINavigationController+DetectionNetState.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UINavigationController+DetectionNetState.h"
#import "DataRequest.h"
#import "NoteNothingNetView.h"

@implementation UINavigationController (DetectionNetState)

//实时检测网络变化  如果没有
- (void)detectionCurrentNetWith:(BOOL)state {
    if (!state) {
        NoteNothingNetView *view=[[NoteNothingNetView alloc] init];
        view.frame=CGRectMake(0,  CGRectGetHeight(self.navigationBar.frame)-30,CGRectGetWidth(self.navigationBar.frame), 30);
        [view addView];
        view.alpha=0.f;
        [self.navigationBar addSubview:view];
        [UIView animateWithDuration:1.0 animations:^{
            view.alpha=1.0;
            view.frame=CGRectMake(0,  CGRectGetHeight(self.navigationBar.frame),CGRectGetWidth(self.navigationBar.frame), 30);
        }];
    } else {
        for (UIView *VC in self.navigationBar.subviews) {
            if ([VC isKindOfClass:[NoteNothingNetView class]]) {
                [UIView animateWithDuration:1.0 animations:^{
                    VC.alpha=0.0;
                    VC.frame=CGRectMake(0,  CGRectGetHeight(self.navigationBar.frame)-30,CGRectGetWidth(self.navigationBar.frame), 30);
                } completion:^(BOOL finished) {
                    [VC removeFromSuperview];
                }];
            }
        }
    }
}


@end
