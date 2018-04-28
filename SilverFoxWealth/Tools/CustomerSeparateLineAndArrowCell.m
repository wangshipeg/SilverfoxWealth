
#import "CustomerSeparateLineAndArrowCell.h"

@implementation CustomerSeparateLineAndArrowCell


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (ViOS8) {
//        CGContextRef context=UIGraphicsGetCurrentContext();
//        CGContextSetStrokeColorWithColor(context, [UIColor typefaceGrayColor].CGColor);
//        CGContextSetLineWidth(context, 1);
//        UIBezierPath *path=[UIBezierPath bezierPath];
//        [path moveToPoint:CGPointMake(15, rect.size.height)];
//        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
//        CGContextAddPath(context, path.CGPath);
//        CGContextStrokePath(context);
        
        UIImage *arrowImage=[UIImage imageNamed:@"AllowRight.png"];
        CGSize arrowImageSize=arrowImage.size;
        [arrowImage drawInRect:CGRectMake(rect.size.width-15-arrowImageSize.width, (rect.size.height-arrowImageSize.height)/2, 7, 12)];
    } else {
        UIView *separateLineView =[[UIView alloc] init];
        separateLineView.backgroundColor=[UIColor typefaceGrayColor];
        separateLineView.frame=CGRectMake(0, CGRectGetHeight(rect)-0.5, CGRectGetWidth(rect), 0.5);
        [self addSubview:separateLineView];
        
        UIImage *arrowImage=[UIImage imageNamed:@"AllowRight.png"];
        UIImageView *arrowIV=[[UIImageView alloc] initWithImage:arrowImage];
        CGSize arrowImageSize=arrowImage.size;
        arrowIV.frame=CGRectMake(rect.size.width-15-arrowImageSize.width, (rect.size.height-arrowImageSize.height)/2, arrowImageSize.width, arrowImageSize.height);
        [self addSubview:arrowIV];
        
    }
    
    
}







@end
