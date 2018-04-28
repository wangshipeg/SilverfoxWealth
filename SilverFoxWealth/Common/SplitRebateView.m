//
//  SplitRebateView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/9/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SplitRebateView.h"
#import "StringHelper.h"
#import "DataRequest.h"
#import "IndividualInfoManage.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "WithoutAuthorization.h"
#import "VCAppearManager.h"


@implementation SplitRebateView
{
    UIView *upLayerView; //背景视图
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=10.0;
}

- (void)showSplitView {
    
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    if (![window.subviews containsObject:self]) {
        CGRect windowFrame=window.frame;
        windowFrame.origin.y =  windowFrame.origin.y + 32;
        windowFrame.size.height = windowFrame.size.height - 64;
        
        UIView *overlayView=[[UIView alloc] initWithFrame:windowFrame];
        overlayView.backgroundColor=[UIColor clearColor];
        if (!upLayerView) {
            upLayerView=[[UIView alloc] initWithFrame:windowFrame];
        }
        upLayerView.backgroundColor=[UIColor blackColor];
        upLayerView.alpha=0.0;
        [overlayView addSubview:upLayerView];
        [window addSubview:overlayView];
        
        [UIView animateWithDuration:0.6 animations:^{
            upLayerView.alpha=0.3;
        }];
        
        UIImage *image=[UIImage imageNamed:@"NotSplit.png"];
        UIColor *color=[[UIColor alloc] initWithPatternImage:image];
        self.redBackView.backgroundColor=color;
        self.center=overlayView.center;
        [self showFrontState];
        [overlayView addSubview:self];
    }
}

- (void)dismissView {
    [UIView animateWithDuration:0.3 animations:^{
        upLayerView.alpha=0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}


//拆之前的状态
- (void)showFrontState {
    self.titleLB.hidden=NO;
    self.titleLB.text=@"银狐财富赠送给您一个红包，\n 赶紧拆开试试运气吧~";
    self.splitBT.hidden=NO;
    
    
    self.alreadyTopLB.hidden=YES;
    self.alreadyMiddleLB.hidden=YES;
    self.alreadyBottomLB.hidden=YES;
}

//拆分之后 动画前 的状态
- (void)showBehindOneState {
    self.titleLB.hidden=YES;
    self.splitBT.hidden=YES;
}

//动画后
- (void)showBehindTwoState {
    self.alreadyTopLB.hidden = NO;
    self.alreadyTopLB.text = @"恭喜您获得分享红包";
    self.alreadyMiddleLB.hidden = NO;
    self.alreadyBottomLB.hidden = NO;
    self.alreadyBottomLB.text = @"已存入我的红包，可用于投资";
}


- (IBAction)splitRebateAction:(UIButton *)sender {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] shareSucceedAchieveRebateWithcustomerId:user.customerId callback:^(id obj) {
        DLog(@"获取红包结果===%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=obj;
            if ([[dic objectForKey:@"code"] integerValue]==200) {
                NSString *valueStr=[[dic objectForKey:@"msg"] stringValue];
                [self animationShowRebateValue:valueStr];
            }else {
                [SVProgressHUD showErrorWithStatus:@"红包获取失败!"];
            }
        }
        
        //需要授权
        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
            
        }
    }];
}

- (void)animationShowRebateValue:(NSString *)rabateValue {
    self.alreadyMiddleLB.attributedText=[StringHelper renderRebateAmountWith:rabateValue valueFont:50 yuanFont:16];
    [self showBehindOneState];
    [UIView animateWithDuration:1.0 animations:^{
        _redBackView.frame=CGRectMake(CGRectGetMinX(_redBackView.frame), CGRectGetMinY(_redBackView.frame)-72, CGRectGetWidth(_redBackView.frame), CGRectGetHeight(_redBackView.frame));
    } completion:^(BOOL finished) {
        [self showBehindTwoState];
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:3.0];
    }];
}

@end
