//
//  NotDataView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NotDataView.h"
#import "UILabel+LabelStyle.h"


@implementation NotDataView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor backgroundGrayColor];
        UIView *contentBackView=[[UIView alloc] init];
        [self addSubview:contentBackView];
        contentBackView.backgroundColor=[UIColor backgroundGrayColor];
        [contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@160);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        
        UIImageView *foxImageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoDataFox.png"]];
        [contentBackView addSubview:foxImageV];
        [foxImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentBackView.mas_top);
            make.width.equalTo(@130);
            make.height.equalTo(@122);
            make.centerX.equalTo(contentBackView.mas_centerX).offset(18);
        }];
        
        _titleLB=[[UILabel alloc] init];
        [contentBackView addSubview:_titleLB];
        _titleLB.text=@"------";
        [_titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor zheJiangBusinessRedColor]];
        _titleLB.textAlignment=NSTextAlignmentCenter;
        [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(foxImageV.mas_bottom).offset(10);
            make.left.equalTo(contentBackView.mas_left).offset(15);
            make.right.equalTo(contentBackView.mas_right).offset(-15);
            make.height.equalTo(@20);
        }];
    }
    return self;
}



@end
