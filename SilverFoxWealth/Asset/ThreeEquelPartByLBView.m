//
//  ThreeEquelPartByLBView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ThreeEquelPartByLBView.h"
#import "UILabel+LabelStyle.h"

@implementation ThreeEquelPartByLBView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        //获得/消耗渠道
        _twoLB=[[UILabel alloc] init];
        [_twoLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
        [self addSubview:_twoLB];
        [_twoLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(10);
            make.height.equalTo(@20);
            make.width.equalTo(@200);
        }];
        
        //时间
        _oneLB=[[UILabel alloc] init];
        [_oneLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor depictBorderGrayColor]];
        [self addSubview:_oneLB];
        [_oneLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.twoLB.mas_bottom).offset(5);
            make.height.equalTo(@20);
            make.width.equalTo(@160);
        }];
        
        //获得/消耗银子数
        _threeLB=[[UILabel alloc] init];
        [_threeLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
        _threeLB.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_threeLB];
        [_threeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@20);
            //make.width.equalTo(@80);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        
    }
    
    return self;
}

@end
