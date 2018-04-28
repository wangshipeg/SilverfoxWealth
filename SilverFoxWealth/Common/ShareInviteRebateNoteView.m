//
//  ShareInviteRebateNoteView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/9/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShareInviteRebateNoteView.h"

@implementation ShareInviteRebateNoteView
{
    UIView *upLayerView; //背景视图
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=10.0;
}

- (void)show {
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    if (![window.subviews containsObject:self]) {
        CGRect windowFrame = window.frame;
        UIView *overlayView = [[UIView alloc] initWithFrame:windowFrame];
        overlayView.backgroundColor = [UIColor clearColor];
        if (!upLayerView) {
            upLayerView = [[UIView alloc] initWithFrame:windowFrame];
        }
        upLayerView.backgroundColor = [UIColor blackColor];
        upLayerView.alpha = 0.0;
        [overlayView addSubview:upLayerView];
        [window addSubview:overlayView];
        
        [UIView animateWithDuration:0.6 animations:^{
            upLayerView.alpha=0.3;
        }];
        
        self.center = overlayView.center;
        [overlayView addSubview:self];
    }
    
}

- (void)dismissView {
    [UIView animateWithDuration:0.3 animations:^{
        upLayerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}


- (IBAction)shareAction:(UIButton *)sender {
    [self dismissView];
    if (sender.tag == 2) {
        self.immediatelyShareBlock();
    }
}



@end
