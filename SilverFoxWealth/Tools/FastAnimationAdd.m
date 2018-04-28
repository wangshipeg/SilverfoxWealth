

#import "FastAnimationAdd.h"
#import <POP.h>
#import "FastAnimation.h"
#import "UIView+FastAnimation.h"

#define kScaleBindingObject  @"animationParams.scaleBindingObject"

@implementation FastAnimationAdd

+ (void)bindingAnimation:(UIControl *)control
{
    id obj = [[FastAnimationAdd alloc] init];
    [control setValue:obj forKeyPath:kScaleBindingObject];
    [control addTarget:obj action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [control addTarget:obj action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}


+ (void)codeBindAnimation:(UIControl *)control {
    
    id obj = [[FastAnimationAdd alloc] init];
    [control setValue:obj forKeyPath:kScaleBindingObject];
    [control addTarget:obj action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [control addTarget:obj action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
}

- (void)touchDown:(id)sender
{
    [FastAnimation addAnimation:sender];
}

- (void)touchUp:(id)sender
{
    [FastAnimation deleteAnimation:sender];
}



@end
