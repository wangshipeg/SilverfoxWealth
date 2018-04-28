//
//  AuditPassOfJXBankVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AuditPassOfJXBankVC.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "MoreVC.h"
#import "DataRequest.h"
#import "UserInfoUpdate.h"

@interface AuditPassOfJXBankVC ()
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation AuditPassOfJXBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    // Do any additional setup after loading the view.
}
- (void)UIDecorate
{
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"更换手机号";
    self.title = @"更换手机号";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        [weakSelf userQuitLogin:user.customerId];
        [UserInfoUpdate clearUserLocalInfo];
        UIViewController *target = nil;
        for (UIViewController * controller in weakSelf.navigationController.viewControllers) { //遍历
            if ([controller isKindOfClass:[MoreVC class]]) { //这里判断是否为你想要跳转的页面
                target = controller;
            }
        }
        if (target) {
            [weakSelf.navigationController popToViewController:target animated:YES]; //跳转
        }
    };
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SuccessLogo.png"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(218);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    UILabel *successLB = [[UILabel alloc] init];
    successLB.textAlignment = NSTextAlignmentCenter;
    successLB.text = @"更换成功";
    successLB.font = [UIFont systemFontOfSize:14];
    successLB.textColor = [UIColor zheJiangBusinessRedColor];
    [self.view addSubview:successLB];
    [successLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    
    UILabel *contentLB = [[UILabel alloc] init];
    contentLB.textAlignment = NSTextAlignmentCenter;
    contentLB.text = @"您可以使用新手机号登录";
    contentLB.font = [UIFont systemFontOfSize:16];
    contentLB.textColor = [UIColor characterBlackColor];
    [self.view addSubview:contentLB];
    [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(successLB.mas_bottom).offset(30);
        make.width.equalTo(@300);
        make.height.equalTo(@20);
    }];
    
    RoundCornerClickBT *_nextBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_nextBT setTitle:@"我知道了" forState:UIControlStateNormal];
    _nextBT.titleLabel.font = [UIFont systemFontOfSize:16];
    _nextBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
    [_nextBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBT addTarget:self action:@selector(accessFirstVC:) forControlEvents:UIControlEventTouchUpInside];
    [FastAnimationAdd codeBindAnimation:_nextBT];
    [self.view addSubview:_nextBT];
    [_nextBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLB.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
        make.height.equalTo(@45);
    }];
}

- (void)accessFirstVC:(UIButton *)sender {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [self userQuitLogin:user.customerId];
    [UserInfoUpdate clearUserLocalInfo];
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[MoreVC class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }
}

//退出登录  注销
- (void)userQuitLogin:(NSString *)customerId {
    [[DataRequest sharedClient] quitLoginWithcustomerId:customerId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        self.view = nil;
    }
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

