

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommunalInfo.h"


@interface AddCancelButton : NSObject
/**
 *给VC中的某一个textfiled返回一个inputAccessoryView视图
 */
+ (UIView *)addCompleteBTOnVC:(UIViewController *)VC withSelector:(SEL)withSelector title:(NSString *)title ;

/**
 *自定义左边图片按钮 及其 点击事件
 */
+ (void)addCustomBarButtonItemWith:(SEL)clickSelector targetVC:(UIViewController *)targetVC image:(UIImage *)image;

/**
 *自定义右边图片按钮 及其 点击事件
 */
+ (void)addCustomRightBarButtonItemWith:(SEL)clickSelector targetVC:(UIViewController *)targetVC image:(UIImage *)image;

/**
 *自定义右边文字按钮 及其点击事件
 */
+ (void)addCustomRightTextBarButtonItemWith:(SEL)clickSelector targetVC:(UIViewController *)targetVC title:(NSString *)title;
/**
 *给TextField添加leftview
 */
+ (UIView *)addTextFieldLeftViewWithTitle:(NSString *)title width:(CGFloat)width;

/**
 *给TextField添加leftview imageView
 */
+ (UIView *)addTextFieldLeftViewWithImage:(NSString *)imageName width:(CGFloat)width;


@end
