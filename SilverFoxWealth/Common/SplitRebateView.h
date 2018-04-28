//
//  SplitRebateView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/9/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplitRebateView : UIView
//公用视图
@property (strong, nonatomic) IBOutlet UIView *redBackView; //需要做动画的视图
@property (nonatomic, strong) UIViewController *succeedVC;

//拆分前视图
@property (strong, nonatomic) IBOutlet UILabel *titleLB; 
@property (strong, nonatomic) IBOutlet UIButton *splitBT;

//拆分后视图
@property (strong, nonatomic) IBOutlet UILabel *alreadyTopLB;
@property (strong, nonatomic) IBOutlet UILabel *alreadyMiddleLB;
@property (strong, nonatomic) IBOutlet UILabel *alreadyBottomLB;

- (void)showSplitView;






@end
