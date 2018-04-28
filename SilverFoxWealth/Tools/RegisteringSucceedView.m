//
//  RegisteringSucceedView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RegisteringSucceedView.h"
#import <POP.h>
#import "StringHelper.h"

@interface RegisteringSucceedView()

@property (nonatomic, strong) UILabel *addLB; //显示本次加了多少银子
@property (nonatomic, strong) UIImageView *silverIM; //银子图片
@property (nonatomic, strong) UILabel *continuationLB; //连续签到多少次
@property (nonatomic, strong) UIView *backView; //addLB和silverIM的背景图

@end

@implementation RegisteringSucceedView


- (instancetype)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=NO;
        
        _backView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(frame), 20)];
        _backView.backgroundColor=[UIColor clearColor];
        [self addSubview:_backView];
        
        _addLB=[[UILabel alloc] initWithFrame:CGRectMake(27, 3, 33, 15)];
        //origin.x最终为10
        _addLB.backgroundColor=[UIColor clearColor];
        _addLB.font=[UIFont systemFontOfSize:11];
        _addLB.textColor=[UIColor zheJiangBusinessRedColor];
        [_backView addSubview:_addLB];
        
        _silverIM=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_addLB.frame), 3, 15, 15)];//初始位置为隐藏  origin.y 最终为10
        _silverIM.image=[UIImage imageNamed:@"SilverIM.png"];
        [_backView addSubview:_silverIM];
        
        _continuationLB=[[UILabel alloc] initWithFrame:CGRectMake(30, 20, self.frame.size.width-35, 30)];
        _continuationLB.numberOfLines = 0;
        _continuationLB.textAlignment = NSTextAlignmentCenter;
        _continuationLB.backgroundColor=[UIColor clearColor];
        _continuationLB.text=@"连续领了\n0天";
        _continuationLB.textColor=[UIColor zheJiangBusinessRedColor];
        _continuationLB.font=[UIFont systemFontOfSize:10];
        [self addSubview:_continuationLB];
        
    }
    return self;
}

//连续签到数量开始增加
- (void)showOneStepWith:( void (^)(BOOL isfinish))finishBlock {
    
    //连续签到多少天 数值改变动画
    POPBasicAnimation *label=[POPBasicAnimation animation];
    label.duration=1.0;
    //动画方式
    label.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    POPAnimatableProperty *prop=[POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
        //obj就是label
        prop.readBlock=^(id obj, CGFloat values[]){
            float readFloat=[[StringHelper findNumFromStr:[obj description]] floatValue];
            values[0] = readFloat;
        };
        prop.writeBlock = ^(id obj,const CGFloat values[]) {
            NSInteger interValue=(NSInteger)values[0];
            [obj setText:[NSString stringWithFormat:@"连续领了\n%ld天",(long)interValue]];
        };
        prop.threshold=0.01;
    }];
    
    label.property=prop;
    label.fromValue=@(0);
    label.toValue=@(_days);
    label.completionBlock = ^(POPAnimation *anim,BOOL finished) {
        if (finished) {
            [self showTwoStepWith:^(BOOL isfinish) {
                finishBlock(isfinish);
            }];
        }
    };
    [_continuationLB pop_addAnimation:label forKey:@"continuationLB"];
    
}

//银子和数值 从天而降
- (void)showTwoStepWith:(void(^)(BOOL isfinish))finishBlock {
    
    _addLB.text=[NSString stringWithFormat:@"+%ld两",(long)_silverNum];
    POPDecayAnimation *decay=[POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    decay.velocity=@(70.0); //越小越往上
    decay.fromValue=@(-20.0);
    decay.completionBlock = ^(POPAnimation *anim,BOOL finished) {
        finishBlock(finished);
    };
    [_backView.layer pop_addAnimation:decay forKey:@"decay"];    
}






























@end
