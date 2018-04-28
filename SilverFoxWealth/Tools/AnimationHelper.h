
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <POP.h>


@interface AnimationHelper : NSObject


/**
 *lable上 数值改变的动画
 */
+ (POPBasicAnimation *)addValueChangeAnimationWithFinallyValue:(double)finallyValue anmationCompletion:(void(^)())anmationCompletion;

/**
 *lable上 数值改变的动画
 */
+ (POPBasicAnimation *)addValueChangeAnimationThreeWithFinallyValue:(double)finallyValue anmationCompletion:(void(^)())anmationCompletion;


/**
 *衰减动画
 */
+ (POPDecayAnimation *)addDecayAnimationWithFromeValue:(float)fromeValue propertyName:(NSString *)propertyName;

/**
 *cell Highligh is 动画
 */
+ (POPBasicAnimation *)cellIsHighlightedAnimation;

/**
 *cell Highligh no 动画
 */
+ (POPSpringAnimation *)cellNOHighlightedAnimation;


@end
