//
//  ZeroIndianaDetailVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/8.
//  Copyright © 2016年 apple. All rights reserved.
//
#import "ZeroIndianaDetailVC.h"
#import "TopBottomBalckBorderView.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import "IndianaCommitVC.h"
#import "VCAppearManager.h"
#import "SVProgressHUD.h"

@interface ZeroIndianaDetailVC ()

@property (nonatomic, strong) UIWebView *detailWebView;
@property (nonatomic, strong) TopBottomBalckBorderView *bottomView;
@property (nonatomic, strong) UIButton *changeBT;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation ZeroIndianaDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        _customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        _customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    _customNav.titleLabel.text = self.titleStr;
    self.title = self.titleStr;
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [self setUpViewController:user];
    
    [[SensorsAnalyticsSDK sharedInstance] track:@"IndianaGoodsDetailsView"
                                 withProperties:@{
                                                  @"GoodsName" : self.titleStr,
                                                  @"JoinPrice": @([self.consumeSilver intValue]),
                                                  @"JoinCount": @([self.joinNumStr intValue]),
                                                  }];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [self achieveAssetDataWith:user.customerId];
}

- (void)achieveAssetDataWith:(NSString *)customerId
{
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:customerId callback:^(id obj) {
        DLog(@"即时获取用户信息结果====%@",obj);
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser=obj;
            [IndividualInfoManage updateAccountWith:resultUser];
        }
    }];
}

- (void)setUpViewController:(IndividualInfoManage *)user
{
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    
    self.detailWebView = [[UIWebView alloc] init];
    self.detailWebView.backgroundColor = [UIColor whiteColor];
    self.detailWebView.scalesPageToFit = YES;
    self.detailWebView.opaque = NO;
    [self.view addSubview:self.detailWebView];
    [self.detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"%@activities/silvers/race/detail?goodsId=%@",LOCAL_HOST,_idStr];
    DLog(@"urlString=========%@",urlString);
    NSURL *urlStr = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlStr];
    self.detailWebView.scrollView.bounces = NO;
    [self.detailWebView loadRequest:request];
    [_detailWebView reload];
    
    _bottomView = [[TopBottomBalckBorderView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _changeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeBT.layer.cornerRadius = 5;
    _changeBT.layer.masksToBounds = YES;
    [_bottomView addSubview:_changeBT];
    [_changeBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_changeBT addTarget:self action:@selector(checkChangeBT:) forControlEvents:UIControlEventTouchUpInside];
    [_changeBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    
    if (user.customerId.length == 0) {
        [_changeBT setTitle:@"去登录" forState:UIControlStateNormal];
        _changeBT.userInteractionEnabled = YES;
        _changeBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
        return;
    }
    if ([self.stockStr integerValue] <= [self.joinNumStr integerValue]) {
        [_changeBT setTitle:@"已开奖" forState:UIControlStateNormal];
        _changeBT.userInteractionEnabled = NO;
        _changeBT.backgroundColor = [UIColor typefaceGrayColor];
        return;
    }
    
    if ([user.silverNumber intValue] >= [_consumeSilver intValue]) {
        [_changeBT setTitle:@"马上夺宝" forState:UIControlStateNormal];
        _changeBT.userInteractionEnabled = YES;
        _changeBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
    }
    if ([user.silverNumber intValue] < [_consumeSilver intValue]){
        [_changeBT setTitle:@"银子不足" forState:UIControlStateNormal];
        _changeBT.userInteractionEnabled = NO;
        _changeBT.backgroundColor = [UIColor typefaceGrayColor];
    }
}

- (void)checkChangeBT:(UIButton *)sender
{
    [MobClick event:@"snatch_detail_snatch_now"];
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (!user) {
        [VCAppearManager presentLoginVCWithCurrentVC:self];
        return;
    }
    IndianaCommitVC *commitVC = [[IndianaCommitVC alloc] init];
    commitVC.idStr = _idStr;
    commitVC.consumeSilver = _consumeSilver;
    commitVC.nameStr = _titleStr;
    [self.navigationController pushViewController:commitVC animated:YES];
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

