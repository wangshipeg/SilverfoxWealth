

#import "AnimationHelper.h"


@implementation AnimationHelper

//数值改变动画
+ (POPBasicAnimation *)addValueChangeAnimationWithFinallyValue:(double)finallyValue anmationCompletion:(void(^)())anmationCompletion {
    
    POPBasicAnimation *label=[POPBasicAnimation animation];
    label.duration=1.0;
    //动画方式
    label.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    POPAnimatableProperty *prop=[POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
        //obj就是label
        prop.readBlock=^(id obj, CGFloat values[]){
            values[0] = [[obj description] doubleValue];
        };
        prop.writeBlock = ^(id obj,const CGFloat values[]) {
            [obj setText:[NSString stringWithFormat:@"%.2f",values[0]]];
        };
        prop.threshold=0.01;
    }];
    
    label.property=prop;
    label.fromValue=@(0);
    label.toValue=@(finallyValue);
    
    label.completionBlock = ^(POPAnimation *anim,BOOL finished) {
        if (finished) {
            anmationCompletion();
        }
    };
    
    return label;
}
+ (POPBasicAnimation *)addValueChangeAnimationThreeWithFinallyValue:(double)finallyValue anmationCompletion:(void(^)())anmationCompletion
{
    POPBasicAnimation *label=[POPBasicAnimation animation];
    label.duration=1.0;
    //动画方式
    label.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    POPAnimatableProperty *prop=[POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
        //obj就是label
        prop.readBlock=^(id obj, CGFloat values[]){
            values[0] = [[obj description] doubleValue];
        };
        prop.writeBlock = ^(id obj,const CGFloat values[]) {
            [obj setText:[NSString stringWithFormat:@"%.3f",values[0]]];
        };
        prop.threshold=0.01;
    }];
    
    label.property=prop;
    label.fromValue=@(0);
    label.toValue=@(finallyValue);
    
    label.completionBlock = ^(POPAnimation *anim,BOOL finished) {
        if (finished) {
            anmationCompletion();
        }
    };
    
    return label;
}

//签到视图动画消失
+ (POPDecayAnimation *)addDecayAnimationWithFromeValue:(float)fromeValue propertyName:(NSString *)propertyName {
    
    POPDecayAnimation *decay=[POPDecayAnimation animationWithPropertyNamed:propertyName];
    decay.velocity=@(100.0);
    decay.fromValue=@(fromeValue);
    return decay;
    
}

+ (POPBasicAnimation *)cellIsHighlightedAnimation {
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.duration = 0.1;
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
    return scaleAnimation;
}

+ (POPSpringAnimation *)cellNOHighlightedAnimation {
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
    scaleAnimation.springBounciness = 20.f;
    return scaleAnimation;
}
























@end


