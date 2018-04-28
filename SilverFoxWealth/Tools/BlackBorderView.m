

#import "BlackBorderView.h"

@implementation BlackBorderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.masksToBounds=YES;
    self.layer.borderWidth=0.5;
    self.layer.borderColor=[UIColor colorWithRed:216/255. green:215/255. blue:215/255. alpha:1.000].CGColor;
}


@end
