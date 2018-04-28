
#import "CustomerTopAndBottomSeparateLineCell.h"

@implementation CustomerTopAndBottomSeparateLineCell


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor typefaceGrayColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, -0.5)]; //上线
    [path addLineToPoint:CGPointMake(rect.size.width, -0.5)];
    [path moveToPoint:CGPointMake(0, rect.size.height)]; //下线
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
}


@end
