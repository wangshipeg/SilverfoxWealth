
#import "NSObject+FastAnimation.h"
#import <UIKit/UIKit.h>
#import "UIControl+FastAnimation.h"
#import <objc/runtime.h>





@implementation NSObject (FastAnimation)

- (void)swizzle_awakeFromNib
{
    //执行原本的awakeFromNib方法
    [self swizzle_awakeFromNib];
    
    UIControl *control = (UIControl *)self;
    //绑定动画
    if ([control isKindOfClass:UIControl.class]) {
        [control bindingFAAnimation];
    }
}

+ (void)load
{
    Method original, swizzle;
    original = class_getInstanceMethod(self, @selector(awakeFromNib));
    swizzle = class_getInstanceMethod(self, @selector(swizzle_awakeFromNib));
    //交换两个方法的实现 就是说调用swizzle方法的时候执行original方法 反之亦然
    method_exchangeImplementations(original, swizzle);
}

@end
