//
//  CustomFont.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UIFont+CustomFont.h"

#define kWidth [UIScreen mainScreen].bounds.size.width

@implementation UIFont (CustomFont)

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize
{
    if (kWidth == 320) {
        fontSize = fontSize - 1;
    }else if(kWidth == 375) {
        fontSize = fontSize;
    }else{
        fontSize = fontSize + 1;
    }
    UIFont *newFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    UIFontDescriptor *ctfFont = newFont.fontDescriptor;
    
    NSString *fontString = [ctfFont objectForKey:@"NSFontNameAttribute"];
    return [UIFont fontWithName:fontString size:fontSize];
}

@end

