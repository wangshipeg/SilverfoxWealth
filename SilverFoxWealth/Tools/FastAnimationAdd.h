
#import <Foundation/Foundation.h>
#import "ControlFastAnimationProtocol.h"


@interface FastAnimationAdd : NSObject<ControlFastAnimationProtocol>

- (void)touchDown:(id)sender;
- (void)touchUp:(id)sender;


//使用代码时 调用绑定动画
+ (void)codeBindAnimation:(UIControl *)control;

@end
