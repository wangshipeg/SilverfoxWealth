//
//  RoundCornerLB.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RoundCornerLB.h"

@implementation RoundCornerLB


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius=5.0;
    self.layer.masksToBounds=YES;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor typefaceGrayColor]);
    
    
}


@end
