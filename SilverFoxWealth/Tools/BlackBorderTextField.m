
#import "BlackBorderTextField.h"

@implementation BlackBorderTextField

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.masksToBounds=YES;
    self.layer.borderColor=[UIColor  typefaceGrayColor].CGColor;
    self.layer.borderWidth=0.5;
}
@end
