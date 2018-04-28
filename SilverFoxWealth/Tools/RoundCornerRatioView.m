//
//  RoundCornerRatioView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RoundCornerRatioView.h"

@implementation RoundCornerRatioView


// Only override drawRect: if you perform custom drawing.

- (void)drawRect:(CGRect)rect {

    self.layer.masksToBounds=YES;
    self.layer.borderWidth=1.0;
    self.layer.borderColor=[UIColor clearColor].CGColor;
    self.layer.cornerRadius=10;
    
    if (_oneRatio&&_twoRatio&&_threeRatio) {
        
        CGContextRef context=UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 49/255., 192/255., 25/255., 1.0);
        CGRect oneframe=CGRectMake(0, 0, rect.size.width*_oneRatio/100, rect.size.height);
        CGContextAddRect(context, oneframe);
        CGContextFillPath(context);
        
        CGContextSetRGBFillColor(context, 40/255., 110/255., 183/255., 1.0);
        CGRect twoframe=CGRectMake(rect.size.width*_oneRatio/100, 0, rect.size.width*_twoRatio/100, rect.size.height);
        CGContextAddRect(context, twoframe);
        CGContextFillPath(context);
        
        CGContextSetRGBFillColor(context, 192/255., 25/255., 32/255., 1.0);
        CGRect threeframe=CGRectMake(rect.size.width*_oneRatio/100+rect.size.width*_twoRatio/100, 0, rect.size.width*_threeRatio/100, rect.size.height);
        CGContextAddRect(context, threeframe);
        CGContextFillPath(context);
        
    }
    
    
}
























@end
