
//底部一条虚线
#import "BottomDashView.h"

@implementation BottomDashView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor typefaceGrayColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGFloat lengths[] = {10,10}; //均匀虚线  先绘制10个点 再绘制十个点
    //20 为count  count的值等于lengths的长度
    //第二个参数的意思是 虚线先从lengths中第一个参数里减去这个值的地方开始
    CGContextSetLineDash(context, 0, lengths, 20);
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(15, rect.size.height-0.5)]; //下线
    [path addLineToPoint:CGPointMake(rect.size.width-15, rect.size.height-0.5)];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
}
@end
