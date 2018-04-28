//
//  TopBlackLineView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TopBlackLineView.h"

@implementation TopBlackLineView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor typefaceGrayColor].CGColor);
    CGContextSetLineWidth(context, 1);
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,0)];
    [path addLineToPoint:CGPointMake(rect.size.width, 0)];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
}

@end
