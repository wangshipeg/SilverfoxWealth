//
//  VipCenterViewController.m
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "VipCenterViewController.h"
#import "VipCenterView.h"
#import "UserInfoUpdate.h"
#import "DataRequest.h"
#import "IndividualInfoManage.h"
#import <MJRefresh.h>
#import "NewHTMLVC.h"

@interface VipCenterViewController ()

@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) VipCenterView *vipView;
@end

@implementation VipCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavView];
    [self updateUserInfo];
    
    [self creatView];
}

- (void)achieveMemberPrivilegesDataWithType:(NSString *)type {
    [[DataRequest sharedClient] requestMemberPrivilegesWithType:type Callback:^(id obj) {
        DLog(@"%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            self.vipView.dict = obj;
        }
    }];
}

- (void)updateUserInfo {
    [UserInfoUpdate updateUserInfoWithTargerVC:self];
    [self achieveMemberPrivilegesDataWithType:@"0"];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] requestCollectingOfThePrincipalWithCustomerId:user.customerId Callback:^(id obj) {
        DLog(@"%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            self.vipView.unPaybackPrincipalDict = obj;
        }
    }];
}

- (void)creatView {
    [self.view addSubview:self.vipView];
    [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(IS_iPhoneX ? iPhoneX_Navigition_Bar_Height : 64, 0, 0, 0));
    }];
}
- (void)setUpNavView {
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"会员中心";
    [_customNav.rightButton setTitle:@"等级说明" forState:UIControlStateNormal];
    self.title = @"会员中心";
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    self.customNav.leftViewController = ^(){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.customNav.rightButtonHandle = ^{
        NewHTMLVC *html = [[NewHTMLVC alloc] init];
        html.work = MemberLevelInstructions;
        [weakSelf.navigationController pushViewController:html animated:YES];
    };
}

#pragma mark ——— getter

- (VipCenterView *)vipView {
    if (!_vipView) {
        _vipView = [[VipCenterView alloc] init];
        _vipView.vipVC = self;
    }
    return _vipView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
