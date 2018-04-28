
#import "FastAnimiationUitls.h"

Class animationClassForString(NSString *animationType) {
    Class animationClass = NSClassFromString(animationType);
    if (animationClass == nil) {
        animationClass = NSClassFromString([@"FastAnimation" stringByAppendingString:animationType]);
    }
    return animationClass;
    
}

