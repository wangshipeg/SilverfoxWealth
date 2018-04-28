//
//  RegisteringView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RegisteringView.h"

@implementation RegisteringView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=10;
}


@end
