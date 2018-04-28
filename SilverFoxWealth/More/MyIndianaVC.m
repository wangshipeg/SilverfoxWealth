//
//  MyIndianaVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyIndianaVC.h"
#import "EndViewController.h"
#import "BeingViewController.h"

@interface MyIndianaVC ()

@end

@implementation MyIndianaVC


- (void)viewDidLoad {
    [super viewDidLoad];
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"我的夺宝";
    self.title = @"我的夺宝";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.titleArray = @[@"进行中",@"已开奖"];
    BeingViewController *oneVC = [[BeingViewController alloc] init];
    EndViewController *twoVC = [[EndViewController alloc] init];
    self.controllerArray = @[oneVC,twoVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

