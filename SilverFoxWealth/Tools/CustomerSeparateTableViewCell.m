

#import "CustomerSeparateTableViewCell.h"

@implementation CustomerSeparateTableViewCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (ViOS8) {
        CGContextRef context=UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor typefaceGrayColor].CGColor);
        CGContextSetLineWidth(context, 1);
        UIBezierPath *path=[UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(15, rect.size.height)];
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
        CGContextAddPath(context, path.CGPath);
        CGContextStrokePath(context);
    } else {
        UIView *separateLineView = [[UIView alloc] init];
        separateLineView.backgroundColor = [UIColor typefaceGrayColor];
        separateLineView.frame = CGRectMake(15, CGRectGetHeight(rect)-0.5, CGRectGetWidth(rect) - 30, 0.5);
        [self addSubview:separateLineView];
    }
}


@end
