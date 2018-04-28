
#import "UIView+FastAnimation.h"
#import <objc/runtime.h>
#import "FastAnimiationUitls.h"


IDENTIFICATION_KEY(animationParams)

@implementation UIView (FastAnimation)

- (NSMutableDictionary *)animationParams
{
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, animationParamsKey);
    if (dictionary == nil) {
        dictionary = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, animationParamsKey, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dictionary;
}

@end
