//
//  GesturePasswordView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "TentacleView.h"


@interface GesturePasswordView ()

@property (nonatomic, strong) UILabel *phoneNumLB;
@property (nonatomic, strong) UILabel *nameLB;

@end

@implementation GesturePasswordView {
    NSMutableArray *buttonArray;
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
}


-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        buttonArray=[NSMutableArray array];
        //这里要修改view的位置        button视图在触摸视图的下面
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        view.center=CGPointMake(self.center.x, self.center.y + 60);
        for (int i=0;i<9;i++) {
            NSInteger row=i/3;
            NSInteger col=i%3; // 0、1、2    0、1、2
            //三等分
            NSInteger distance=frame.size.width/3;
            //
            NSInteger size=50;
            NSInteger margin=(distance-size)/2;
            GesturePasswordButton *bt=[[GesturePasswordButton alloc] initWithFrame:CGRectMake(col*distance+margin, row*distance+margin, size, size)];
            [bt setTag:i];
            [view addSubview:bt];
            [buttonArray addObject:bt];
        }
        frame.origin.y=0;
        [self addSubview:view];
        
        //TentacleView的大小和按钮父视图大小保持一致
        _tentacleView=[[TentacleView alloc] initWithFrame:view.frame];
        [_tentacleView setButtonArray:buttonArray];
        [_tentacleView setTouchBeginDelegate:self];
        [self addSubview:_tentacleView];
        
        //显示状态的label
        _state=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280,40)];
        _state.center=CGPointMake(view.center.x, view.center.y-frame.size.width/2);
        [_state setFont:[UIFont systemFontOfSize:16]];
        [_state setTextColor:[UIColor zheJiangBusinessRedColor]];
        [_state setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_state];
    }
    return self;
}

#pragma -mark TouchBeginDelegate
- (void)gestureTouchBegin {
    //手势开始重置状态label字符为空
    [self.state setText:@""];
}





























@end
