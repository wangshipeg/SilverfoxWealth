//
//  MyBankNotDataView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyBankNotDataView.h"
#import "UILabel+LabelStyle.h"
#import "FastAnimationAdd.h"

@implementation MyBankNotDataView


- (id)initWithFrame:(CGRect)frame noteTitle:(NSString *)noteTitle btTitle:(NSString *)btTitle  {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor backgroundGrayColor];
        UIView *contentBackView=[[UIView alloc] init];
        [self addSubview:contentBackView];
        contentBackView.backgroundColor=[UIColor backgroundGrayColor];
        [contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@200);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(self.mas_width);
            make.top.equalTo(self.mas_top).offset(64);
        }];
        
        UILabel *notLoginLB=[[UILabel alloc] init];
        [contentBackView addSubview:notLoginLB];
        notLoginLB.text = noteTitle;
        [notLoginLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
        notLoginLB.textAlignment = NSTextAlignmentCenter;
        [notLoginLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentBackView.mas_top).offset(30);
            make.left.equalTo(contentBackView.mas_left).offset(15);
            make.right.equalTo(contentBackView.mas_right).offset(-15);
            make.height.equalTo(@20);
        }];
        
        
        RoundCornerClickBT *loginBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
        [contentBackView addSubview:loginBT];
        loginBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        loginBT.titleLabel.font=[UIFont systemFontOfSize:16];
        [loginBT setTitle:btTitle forState:UIControlStateNormal];
        [loginBT addTarget:self action:@selector(logIn:) forControlEvents:UIControlEventTouchUpInside];
        [FastAnimationAdd codeBindAnimation:loginBT];
        [loginBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(notLoginLB.mas_bottom).offset(40);
            make.left.equalTo(contentBackView.mas_left).offset(43);
            make.right.equalTo(contentBackView.mas_right).offset(-43);
            make.height.equalTo(@45);
        }];
    }
    return self;
}

- (void)bindingBlockWith:(BindingBlock)bindingBlock{
    _bindingBlock = bindingBlock;
}

- (void)logIn:(UIButton *)sender {
    _bindingBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
