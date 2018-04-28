//
//  RegisteringSucceedView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

//本类用来定制 签到成功后 切换出来的视图
#import <UIKit/UIKit.h>

@interface RegisteringSucceedView : UIView

@property (nonatomic, assign) NSInteger silverNum; //银子数量
@property (nonatomic, assign) NSInteger days; //连续签到多少天

- (instancetype)initWithFrame:(CGRect)frame;

//连续签到数量开始增加
- (void)showOneStepWith:( void (^)(BOOL isfinish))finishBlock ;


@end
