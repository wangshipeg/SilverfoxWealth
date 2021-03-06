//
//  UIBarButtonItem+UdeskAddition.m
//  UdeskSDK
//
//  Created by xuchen on 2017/12/15.
//  Copyright © 2017年 Udesk. All rights reserved.
//

#import "UIBarButtonItem+UdeskAddition.h"
#import "UdeskViewExt.h"
#import "UIImage+UdeskSDK.h"
#import "UdeskSDKConfig.h"
#import "UdeskStringSizeUtil.h"

@implementation UIBarButtonItem (UdeskAddition)

+ (UIBarButtonItem *)itemWithIcon:(UIImage *)icon target:(id)target action:(SEL)action {
    
    @try {
        
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [customView addGestureRecognizer:tap];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        if (icon) {
            [btn setBackgroundImage:icon forState:UIControlStateNormal];
        }
        btn.frame = CGRectMake(0, 0, btn.currentBackgroundImage.size.width, btn.currentBackgroundImage.size.height);
        btn.ud_centerY = customView.ud_centerY;
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:btn];
        return [[UIBarButtonItem alloc] initWithCustomView:customView];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    @try {
        
        UIImage *backImage = [UIImage ud_defaultBackImage];
        CGSize backTextSize = [UdeskStringSizeUtil textSize:title withFont:[UIFont systemFontOfSize:17] withSize:CGSizeMake(70, 30)];
        
        UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBarButton.frame = CGRectMake(0, 0, backTextSize.width+backImage.size.width+20, backTextSize.height);
        [leftBarButton setTitle:title forState:UIControlStateNormal];
        backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [leftBarButton setTintColor:[UdeskSDKConfig sharedConfig].sdkStyle.navBackButtonColor];
        [leftBarButton setImage:backImage forState:UIControlStateNormal];
        [leftBarButton setTitleColor:[UdeskSDKConfig sharedConfig].sdkStyle.navBackButtonColor forState:UIControlStateNormal];
        [leftBarButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        [leftBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        
        if (ud_isIOS11) {
            leftBarButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
            [leftBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5 * UD_SCREEN_WIDTH/375.0,0,0)];
            [leftBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -2 * UD_SCREEN_WIDTH/375.0,0,0)];
        }
        
        return [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}

+ (UIBarButtonItem *)rightItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    @try {
        
        CGSize transferTextSize = [UdeskStringSizeUtil textSize:title withFont:[UIFont systemFontOfSize:16] withSize:CGSizeMake(85, 30)];
        UIImage *rightImage = [UIImage ud_defaultTransferImage];
        
        //导航栏右键
        UIButton *navBarRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [navBarRightButton setTitle:title forState:UIControlStateNormal];
        rightImage = [rightImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [navBarRightButton setTintColor:[UdeskSDKConfig sharedConfig].sdkStyle.transferButtonColor];
        [navBarRightButton setImage:rightImage forState:UIControlStateNormal];
        navBarRightButton.frame = CGRectMake(0, 0, transferTextSize.width+rightImage.size.width, transferTextSize.height);
        navBarRightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [navBarRightButton setTitleColor:[UdeskSDKConfig sharedConfig].sdkStyle.transferButtonColor forState:UIControlStateNormal];
        
        if (ud_isIOS11) {
            navBarRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [navBarRightButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0, -5 *UD_SCREEN_WIDTH /375.0)];
            [navBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,-7 * UD_SCREEN_WIDTH/375.0)];
        }
        
        [navBarRightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return [[UIBarButtonItem alloc] initWithCustomView:navBarRightButton];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}

@end
