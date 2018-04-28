

#import "UIControl+FastAnimation.h"
#import "FastAnimiationUitls.h"
#import <objc/runtime.h>
#import "ControlFastAnimationProtocol.h"




@implementation UIControl (FastAnimation)

DEFINE_RW_STRING_PROP(bindingAnimationType, setBindingAnimationType)

- (void)bindingFAAnimation {
    if (self.bindingAnimationType) {
        Class animation = animationClassForString(self.bindingAnimationType);
        NSAssert([animation conformsToProtocol:@protocol(ControlFastAnimationProtocol)], @"If you want to binding an animation, the property 'bindingAnimationType' must a class name and conforms protocol 'FastAnmationProtocol'");
        [animation bindingAnimation:self];
    }
}


@end
