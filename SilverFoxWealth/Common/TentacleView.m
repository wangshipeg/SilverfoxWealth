//
//  TentacleView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TentacleView.h"
#import "GesturePasswordButton.h"
#import <SVProgressHUD.h>
#import "CommunalInfo.h"
#import "PromptLanguage.h"



@implementation TentacleView{
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    NSMutableArray *touchesArray; //存放选中bt的中心点 x,y
    NSMutableArray *touchedArray; //存放已经选中的button的序号 如 num1
    BOOL success;
}

-(id)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        touchesArray=[NSMutableArray arrayWithCapacity:0];
        touchedArray=[NSMutableArray arrayWithCapacity:0];
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=YES;
        success=YES;//默认成功
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint;
    UITouch *touch=[touches anyObject];
    //触摸开始前 移除全部数据
    [touchesArray removeAllObjects];
    [touchedArray removeAllObjects];
    [_touchBeginDelegate gestureTouchBegin];
    success=YES;
    //如果触摸
    if (touch) {
        //获取触摸点
        touchPoint=[touch locationInView:self];
        //从九个button中检查
        for (int i=0; i<_buttonArray.count; i++) {
            GesturePasswordButton *buttonTemp=(GesturePasswordButton *)[_buttonArray objectAtIndex:i];
            //重置 所有button
            [buttonTemp setSuccess:YES];
            [buttonTemp setSelected:NO];
            
            //如果起始点 被包含在button的frame中
            if (CGRectContainsPoint(buttonTemp.frame, touchPoint)) {
                CGRect frameTemp=buttonTemp.frame;
                //button中心点
                CGPoint point=CGPointMake(frameTemp.origin.x+frameTemp.size.width/2, frameTemp.origin.y+frameTemp.size.height/2);
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",point.x],@"x",[NSString stringWithFormat:@"%f",point.y],@"y", nil];
                //保存每一个选中bt的中心点
                [touchesArray addObject:dict];
                lineStartPoint=touchPoint;
            }
            [buttonTemp setNeedsDisplay];
        }

        [self setNeedsDisplay];
    }
    
    
}



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint;
    UITouch *touch=[touches anyObject];
    if (touch) {
        touchPoint=[touch locationInView:self];
        for (int i=0; i<_buttonArray.count; i++) {
            GesturePasswordButton *buttonTemp=(GesturePasswordButton *)[_buttonArray objectAtIndex:i];
            if (CGRectContainsPoint(buttonTemp.frame, touchPoint)) {
                //如果这个bt已经添加进数组中了 
                if ([touchedArray containsObject:[NSString stringWithFormat:@"num%d",i]]) {
                    lineEndPoint=touchPoint;
                    [self setNeedsDisplay];
                    return;
                }
                
                //如果没有包括这个bt 先添加进来
                [touchedArray addObject:[NSString stringWithFormat:@"num%d",i]];
                
                //把这个button设置为选中状态
                [buttonTemp setSelected:YES];
                [buttonTemp setNeedsDisplay];
                
                CGRect frameTemp=buttonTemp.frame;
                CGPoint point=CGPointMake(frameTemp.origin.x+frameTemp.size.width/2, frameTemp.origin.y+frameTemp.size.height/2);
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",point.x],@"x",[NSString stringWithFormat:@"%f",point.y],@"y",[NSString stringWithFormat:@"%d",i],@"num", nil];
                [touchesArray addObject:dict];
                break;
                
            }
        }
        
        lineEndPoint=touchPoint;
        [self setNeedsDisplay];
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableString *resultString=[NSMutableString string];
    
    for (NSDictionary *dic in touchesArray) {
        if (![dic objectForKey:@"num"]) {
            break;
        }
        [resultString appendString:[dic objectForKey:@"num"]];
    }
    
    DLog(@"手势结果resultString===%@",resultString);
    
    if (resultString.length<4&&resultString.length>0) {
        [SVProgressHUD showErrorWithStatus:GesturePasswordForNeedFourSpot];
        //重置状态
        [self enterArgin];
        return;
    }
    
    if (resultString.length==0) {
        return ;
    }
    
    //根据风格传质
    if (_style==1) {
        success=[_verificationDelegate verification:resultString];
    }else {
        success=[_resetDelegate resetPassword:resultString];
    }
    
    for (int i=0; i<touchesArray.count; i++) {
        NSInteger selection=[[[touchesArray objectAtIndex:i] objectForKey:@"num"] intValue];
        GesturePasswordButton *buttonTemp=(GesturePasswordButton *)[_buttonArray objectAtIndex:selection];
        [buttonTemp setSuccess:success];
        [buttonTemp setNeedsDisplay];
    }
    
    [self setNeedsDisplay];
    
    //如果失败  1.5秒后 重置状态
    if (!success) {
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.5]];
        [self enterArgin];
    }
}


- (void)drawRect:(CGRect)rect {
    
    for (int i=0; i<touchesArray.count; i++) {
        CGContextRef context=UIGraphicsGetCurrentContext();
        if (![[touchesArray objectAtIndex:i] objectForKey:@"num"]) {
            [touchesArray removeObjectAtIndex:i];
            continue;
        }
        if (success) {
            CGContextSetRGBStrokeColor(context, 5/255.f, 116/255.f, 232/255.f, 1.0);
        }else{
            CGContextSetRGBStrokeColor(context, 192/255., 25/255., 32/255, 0.7);
        }
        
        CGContextSetLineWidth(context, 2);
        CGContextMoveToPoint(context, [[[touchesArray objectAtIndex:i] objectForKey:@"x"] floatValue], [[[touchesArray objectAtIndex:i] objectForKey:@"y"] floatValue]);
        if (i<touchesArray.count-1) {
            CGContextAddLineToPoint(context, [[[touchesArray objectAtIndex:i+1] objectForKey:@"x"] floatValue], [[[touchesArray objectAtIndex:i+1] objectForKey:@"y"] floatValue]);
        }else{
            if (success) {
                CGContextAddLineToPoint(context, lineEndPoint.x, lineEndPoint.y);
            }
        }
        
        CGContextStrokePath(context);
    }
    
}

//所有bt复位
-(void)enterArgin {
    [touchesArray removeAllObjects];
    [touchedArray removeAllObjects];
    
    for (int i=0; i<_buttonArray.count; i++) {
        GesturePasswordButton *buttonTemp=(GesturePasswordButton *)[_buttonArray objectAtIndex:i];
        [buttonTemp setSelected:NO];
        [buttonTemp setSuccess:YES];
        [buttonTemp setNeedsDisplay];
    }
    [self setNeedsDisplay];
}

@end
