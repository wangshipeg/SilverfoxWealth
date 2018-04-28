//
//  AccountBindingVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AccountBindingVC.h"
#import "AccountBindingCell.h"
#import "DataRequest.h"
#import "RequestOAth.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSAuthDetailViewController.h"
#import <UShareUI/UMSocialUIUtility.h>
#import "SVProgressHUD.h"
#import "UMMobClick/MobClick.h"

@interface AccountBindingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation AccountBindingVC
{
    BOOL isQQ;
    BOOL isWechat;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInitialize];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [self requestAuthCustomer:user];
    
    // Do any additional setup after loading the view.
}

- (void)requestAuthCustomer:(IndividualInfoManage *)user
{
    isQQ = YES;
    isWechat = YES;
    [[DataRequest sharedClient]customerAuthorisationMessageWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"qq"] intValue] == 0) {
                isQQ = NO;
            }
            if ([obj[@"wechat"] intValue] == 0) {
                isWechat = NO;
            }
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AccountBindingCell *cell=[[AccountBindingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.QQOrWachatLB.text = @"QQ账号";
        if (isQQ) {
            cell.isBindingLB.text = @"已绑定";
            cell.isBindingLB.textColor = [UIColor characterBlackColor];
        }else{
            cell.isBindingLB.text = @"未绑定";
            cell.isBindingLB.textColor = [UIColor iconBlueColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        AccountBindingCell *cell=[[AccountBindingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.QQOrWachatLB.text = @"微信账号";
        if (isWechat) {
            cell.isBindingLB.text = @"已绑定";
            cell.isBindingLB.textColor = [UIColor characterBlackColor];
        }else{
            cell.isBindingLB.text = @"未绑定";
            cell.isBindingLB.textColor = [UIColor iconBlueColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (!isQQ) {
            [MobClick event:@"go_band_qq"];
            __weak typeof(self) weakSelf = self;
            UMSAuthInfo *obj = [UMSAuthInfo objectWithType:UMSocialPlatformType_QQ];
            [[UMSocialManager defaultManager] cancelAuthWithPlatform:obj.platform completion:^(id result, NSError *error) {
                [weakSelf authForPlatform:obj];
            }];
        }
    }
    if (indexPath.row == 1) {
        if (!isWechat) {
            [MobClick event:@"go_band_wx"];
            __weak typeof(self) weakSelf = self;
            UMSAuthInfo *obj = [UMSAuthInfo objectWithType:UMSocialPlatformType_WechatSession];
            [[UMSocialManager defaultManager] cancelAuthWithPlatform:obj.platform completion:^(id result, NSError *error) {
                [weakSelf authForPlatform:obj];
            }];
        }
    }
}

- (void)authForPlatform:(UMSAuthInfo *)authInfo
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:authInfo.platform currentViewController:nil completion:^(id result, NSError *error) {
        if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
            UMSocialUserInfoResponse *resp = result;
            authInfo.response = resp;
            NSString *categoryStr = nil;
            NSString *uidOrOpenIdStr = nil;
            if (authInfo.platform == 1) {
                categoryStr = @"1";
            }else if (authInfo.platform == 4)
            {
                categoryStr = @"0";
            }
            uidOrOpenIdStr = resp.unionId;
            IndividualInfoManage *user = [IndividualInfoManage currentAccount];
            [[DataRequest sharedClient]thirdAuthorisationLoginWithCustomerCellphone:user.cellphone password:@"" category:categoryStr openId:uidOrOpenIdStr nickName:authInfo.response.name headImg:authInfo.response.iconurl login:@"1" callback:^(id obj)
             {
                 if ([obj isKindOfClass:[IndividualInfoManage class]]) {
                     IndividualInfoManage *resultObj = obj;
                     [self requestAuthCustomer:resultObj];
                 }
                 if ([obj isKindOfClass:[NSDictionary class]]) {
                     [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
                 }
             }];
        }
    }];
}

- (void)dataInitialize
{
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"账号绑定";
    self.title = @"账号绑定";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.tableView=[[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
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

