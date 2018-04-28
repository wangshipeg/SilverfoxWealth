//
//  UITextField+ForbidCopyTF.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UITextField+ForbidCopyTF.h"

@implementation UITextField (ForbidCopyTF)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
