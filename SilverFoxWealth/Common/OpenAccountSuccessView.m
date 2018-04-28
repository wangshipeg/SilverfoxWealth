//
//  OpenAccountSuccessView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/7/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OpenAccountSuccessView.h"
#import "StringHelper.h"
#import "DataRequest.h"
#import "IndividualInfoManage.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "WithoutAuthorization.h"
#import "MyBonusVC.h"

@implementation OpenAccountSuccessView
{
    UIView *upLayerView; //背景视图
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=10.0;
    
}

- (void)showOpenAccountSuccessView {
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    if (![window.subviews containsObject:self]) {
        window.backgroundColor = [UIColor clearColor];
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

- (IBAction)closevView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        upLayerView.alpha=0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

@end
