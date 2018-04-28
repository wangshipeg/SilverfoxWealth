

#import "RightBlockLineBT.h"

@implementation RightBlockLineBT


// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //在button的右边加上一条黑线
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(rect.size.width-0.5, 0, 0.5, rect.size.height)];
    view.backgroundColor=[UIColor colorWithRed:216/255. green:215/255. blue:215/255. alpha:1.000];
    [self addSubview:view];
    
    
}





























@end
