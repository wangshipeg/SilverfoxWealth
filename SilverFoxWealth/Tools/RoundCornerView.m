//
//  RoundCornerView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RoundCornerView.h"

@implementation RoundCornerView


- (void)drawRect:(CGRect)rect {
    self.layer.masksToBounds=YES;
    self.layer.borderWidth=1.0;
    self.layer.borderColor=[UIColor clearColor].CGColor;
    self.layer.cornerRadius=10;
}


@end
