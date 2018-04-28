//
//  RoundCornerClickBT.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RoundCornerClickBT.h"

@implementation RoundCornerClickBT

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius=5.0;
    self.layer.masksToBounds=YES;
}

@end
