//
//  RoundCornerBT.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RoundCornerBT.h"

@implementation RoundCornerBT

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius=5.0;
    self.layer.masksToBounds=YES;
    self.layer.borderWidth=1.0;
//    self.layer.borderColor=[UIColor co ]
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    if (self.selected) {
        self.layer.borderColor=[UIColor colorWithRed:0.126 green:0.346 blue:0.659 alpha:1.000].CGColor;
    }else{
        self.layer.borderColor=[UIColor colorWithRed:0.811 green:0.807 blue:0.807 alpha:1.000].CGColor;
    }
}


@end
