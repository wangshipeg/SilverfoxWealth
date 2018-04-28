//
//  GesturePasswordButton.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GesturePasswordButton.h"

#define BOUNDS self.bounds

@implementation GesturePasswordButton

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _success=YES;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    //如果选择了
    if (_selected) {
        //绘制 填充色及 画笔的颜色
        //如果是成功状态
        if (_success) {
            CGContextSetRGBStrokeColor(context, 5/255.f, 116/255.f, 232/255.f, 1);
            //控制圆心的颜色
            CGContextSetRGBFillColor(context, 5/255.f, 116/255.f, 232/255.f, 1);
        }else //如果是失败的
        {
            CGContextSetRGBStrokeColor(context, 192/255., 25/255., 32/255., 1.f);
            CGContextSetRGBFillColor(context, 192/255., 25/255., 32/255., 1);
        }
        CGRect frame=CGRectMake(BOUNDS.size.width/2-BOUNDS.size.width/8+1, BOUNDS.size.height/2-BOUNDS.size.height/8, BOUNDS.size.height/4, BOUNDS.size.height/4);
        //画圆心
        CGContextAddEllipseInRect(context, frame);
        //绘制
        CGContextFillPath(context);
        
    }else //如果没有选择
    {
        //外圆圈  正常颜色
        CGContextSetRGBStrokeColor(context, 216/255.f,215/255.f, 215/255.f, 1);
    }
    //线宽 这步可略
    CGContextSetLineWidth(context, 1);
    
    //外灰色描边
    CGRect frame=CGRectMake(1, 1, BOUNDS.size.width-2, BOUNDS.size.height-2);
    
    //椭圆
    CGContextAddEllipseInRect(context, frame);
    
    //填充外圈圆环
    CGContextStrokePath(context);
    
}



















































@end
