

#import "BlackBorderAndSegmentationLineView.h"

@implementation BlackBorderAndSegmentationLineView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //往输入框遮层上 添加黑线
    CGFloat space=CGRectGetWidth(rect)/6;
    for (int i=0; i<5; i++) {
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake((i+1)*space, 0, 0.5, CGRectGetHeight(rect))];
        line.backgroundColor=[UIColor colorWithRed:216/255. green:215/255. blue:215/255. alpha:1.0];
        [self addSubview:line];
    }
    
}


@end
