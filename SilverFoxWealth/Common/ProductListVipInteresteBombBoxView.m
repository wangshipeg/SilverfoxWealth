//
//  ProductListVipInteresteBombBoxView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/4/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ProductListVipInteresteBombBoxView.h"

@implementation ProductListVipInteresteBombBoxView
{
    UIView *upLayerView; //背景视图
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=10.0;
    
}

- (void)showVipIntersterBombBoxView {
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    if (![window.subviews containsObject:self]) {
        window.backgroundColor = [UIColor clearColor];
        CGRect windowFrame = window.frame;
        UIView *overlayView = [[UIView alloc] initWithFrame:windowFrame];
        overlayView.backgroundColor = [UIColor clearColor];
        if (!upLayerView) {
            upLayerView = [[UIView alloc] initWithFrame:CGRectMake(window.frame.size.width - 70, window.frame.size.height - 90 - 50, 50, 50)];
        }
        upLayerView.backgroundColor = [UIColor blackColor];
        upLayerView.alpha = 0.0;
        [overlayView addSubview:upLayerView];
        [window addSubview:overlayView];
        self.frame = windowFrame;
        self.vipInterestImgView.frame = CGRectMake(window.frame.size.width - 70, window.frame.size.height - 90 - 50, 50, 50);
        self.gradeLB.frame = CGRectMake(windowFrame.size.width - 45, windowFrame.size.height - 90 - 75, 20, 20);
        self.vipInterest.frame = CGRectMake(windowFrame.size.width - 45, windowFrame.size.height - 75, 20, 20);
        upLayerView.frame = windowFrame;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.3 animations:^{
            upLayerView.alpha=0.3;
            if (IS_iPhoneX) {
                self.vipInterestImgView.frame = CGRectMake(20, 150, windowFrame.size.width - 40, (windowFrame.size.width - 40) * 503 / 317);
                self.gradeLB.frame = CGRectMake(20, 150 + ((windowFrame.size.width - 40) * 503 / 317) * 223 / 503, windowFrame.size.width - 40, 20);
                self.vipInterest.frame = CGRectMake(20, 150 + ((windowFrame.size.width - 40) * 503 / 317) * 268 / 503, windowFrame.size.width - 40, 20);
            }else{
                self.vipInterestImgView.frame = CGRectMake(20, 50, windowFrame.size.width - 40, (windowFrame.size.width - 40) * 503 / 317);
                self.gradeLB.frame = CGRectMake(20, 50 + ((windowFrame.size.width - 40) * 503 / 317) * 223 / 503, windowFrame.size.width - 40, 20);
                self.vipInterest.frame = CGRectMake(20, 50 + ((windowFrame.size.width - 40) * 503 / 317) * 268 / 503, windowFrame.size.width - 40, 20);
            }
            
            overlayView.frame = windowFrame;
        }];
        [overlayView addSubview:self];
    }
}

- (void)dismiss
{
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    [UIView animateWithDuration:.7 animations:^{
        upLayerView.alpha = 0;
        if (IS_iPhoneX) {
            self.frame = CGRectMake(window.frame.size.width - 70, window.frame.size.height - 90 - 100 - 34 - 40, 0, 0);
            self.vipInterestImgView.frame = CGRectMake(window.frame.size.width - 70, window.frame.size.height - 90 - 100 - 34 - 40, 0, 0);
        } else {
            self.frame = CGRectMake(window.frame.size.width - 70, window.frame.size.height - 90 - 100, 0, 0);
            self.vipInterestImgView.frame = CGRectMake(window.frame.size.width - 70, window.frame.size.height - 90 - 50, 50, 50);
        }
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
