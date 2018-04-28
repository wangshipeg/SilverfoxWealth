//
//  UIView+ViewTools.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIView+ViewTools.h"

@implementation UIView (ViewTools)

- (void)clearSubViews {
    NSArray *array=self.subviews;
    if (array.count>0) {
        for (UIView *vi in array) {
            [vi removeFromSuperview];
        }
    }
}

@end
