//
//  ShareView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShareView.h"
#import <POP.h>


@implementation ShareView
{
    UIView *upLayerView;
}

-(void)show:(ShareToBlock)myblock{
    
    _platformTagBK=myblock;
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    if (![window.subviews containsObject:self]) {
        CGRect windowFrame=window.frame;
        UIView *overlayView=[[UIView alloc] initWithFrame:windowFrame];
        overlayView.backgroundColor=[UIColor clearColor];
        
        upLayerView=[[UIView alloc] initWithFrame:windowFrame];
        upLayerView.backgroundColor=[UIColor blackColor];
        upLayerView.alpha=0.0;
        [overlayView addSubview:upLayerView];
        
        [window addSubview:overlayView];
        
        self.frame=CGRectMake(0, CGRectGetHeight(windowFrame), CGRectGetWidth(windowFrame), CGRectGetHeight(self.frame));
        [overlayView addSubview:self];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [upLayerView addGestureRecognizer:tapGesture];
        
        
        [UIView animateWithDuration:0.2 delay:0.01 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            upLayerView.alpha=0.3;
            self.frame=CGRectMake(0, CGRectGetHeight(windowFrame)-CGRectGetHeight(self.frame), CGRectGetWidth(windowFrame), CGRectGetHeight(self.frame));
        } completion:^(BOOL finished) {
            
        }];
    }
}


-(void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        upLayerView.alpha=0;
        self.frame=CGRectMake(0, CGRectGetMinY(self.frame)+CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
    
    
}

- (IBAction)shareTo:(UIButton *)sender {
    [self dismiss];
    _platformTagBK(sender.tag);
}


- (IBAction)cancelShare:(UIButton *)sender {
    [self dismiss];
}

@end
