//
//  UILabel+LabelStyle.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelStyle)

- (void)decorateLabelStyleWithCharacterFont:(UIFont *)characterFont characterColor:(UIColor *)characterColor ;
//label 高度自适应
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;
//label 宽度自适应
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end
