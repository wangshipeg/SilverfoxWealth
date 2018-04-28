

#import "FastAnimation.h"


@implementation FastAnimation


+ (void)addAnimation:(UIView *)sender {
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.toValue=[NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
    animation.springBounciness=10;
    [sender.layer pop_addAnimation:animation forKey:@"ZoomOutY"];
}

+ (void)deleteAnimation:(UIView *)sender {
    [sender.layer pop_removeAnimationForKey:@"ZoomOutY"];
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    animation.springBounciness = 10;
    [sender.layer pop_addAnimation:animation forKey:@"ZoomOutYReverse"];
}

@end
