//
//  ShadowAndFilletView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShadowAndFilletView.h"

@implementation ShadowAndFilletView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.cornerRadius=5;
    self.layer.shadowColor=[UIColor grayColor].CGColor;
    self.layer.shadowOffset=CGSizeMake(2, 2);
    self.layer.shadowOpacity=0.5;
    self.layer.shadowRadius=5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

@end
