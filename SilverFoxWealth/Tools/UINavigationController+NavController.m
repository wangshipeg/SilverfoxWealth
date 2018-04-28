//
//  UINavigationController+NavController.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/8/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UINavigationController+NavController.h"

@implementation UINavigationController (NavController)

+ (void)itemWithViewComtroller:(UIViewController *)controller{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 15);
    [button setImage:[UIImage imageNamed:@"QQ.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *liftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    controller.navigationItem.leftBarButtonItems = @[spaceItem,liftItem];
}
- (void)backViewController
{
    [self popViewControllerAnimated:YES];
}
@end
