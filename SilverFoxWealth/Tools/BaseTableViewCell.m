

#import "BaseTableViewCell.h"


@implementation BaseTableViewCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIImage *arrowImage=[UIImage imageNamed:@"AllowRight.png"];
    CGSize arrowImageSize=arrowImage.size;
    [arrowImage drawInRect:CGRectMake(rect.size.width - 15 - arrowImageSize.width, (rect.size.height-arrowImageSize.height)/2, arrowImageSize.width, arrowImageSize.height)];
}



@end
