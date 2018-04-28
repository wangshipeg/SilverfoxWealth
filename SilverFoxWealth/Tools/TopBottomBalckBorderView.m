//
//  TopBottomBalckBorderView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TopBottomBalckBorderView.h"

@implementation TopBottomBalckBorderView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor typefaceGrayColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)]; //上线
    [path addLineToPoint:CGPointMake(rect.size.width, 0)];
    [path moveToPoint:CGPointMake(0, rect.size.height-0.5)]; //下线
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height-0.5)];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
}



















@end
