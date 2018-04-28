
#import "BlackBorderBT.h"


@implementation BlackBorderBT


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.layer.masksToBounds=YES;
    self.layer.borderWidth=0.3;
    self.layer.borderColor=[UIColor typefaceGrayColor].CGColor;
}


@end
