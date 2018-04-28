//
//  SilverDetailPageVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SilverDetailPageVC.h"
#import "TopBlackLineView.h"
#import "BlackBorderBT.h"
#import "GoodsChangeVC.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import "VCAppearManager.h"
#import "SignHelper.h"
#import "SCMeasureDump.h"
#import "FastAnimationAdd.h"
#import "GTMBase64.h"
#import "WithoutAuthorization.h"
#import "MySilverVC.h"
#import "RoundCornerClickBT.h"
#import "UMMobClick/MobClick.h"
#import "SVProgressHUD.h"

@interface SilverDetailPageVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *detailWebView;
@property (nonatomic, strong) TopBlackLineView *bottomView;
@property (nonatomic, strong) RoundCornerClickBT *changeBT;

@property (nonatomic, strong) NSString *requestString;
@property (nonatomic, strong) NSString *silverNB;
@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) NSString *moreTimesStr;

@property (nonatomic, strong) NSString *conditionReachedstr;
@property (nonatomic, strong) NSString *silverEnoughOrNot;
@end

@implementation SilverDetailPageVC
{
    BOOL isCanChange;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isCanChange = YES;
    [self UIDecorate];
    [self loadUrlDetail];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadUrlDetail {
    NSString *urlString=[NSString stringWithFormat:@"%@goods/detail?goodsId=%@",LOCAL_HOST,_idStr];
    NSURL *urlStr=[NSURL URLWithString:urlString];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:urlStr];
    self.detailWebView.scalesPageToFit = YES;
    self.detailWebView.scrollView.bounces=NO;
    [self.detailWebView loadRequest:request];
}

- (void)UIDecorate
{
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = _nameStr;
    self.title = _nameStr;
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.view.backgroundColor=[UIColor whiteColor];

    _detailWebView=[[UIWebView alloc] init];
    _detailWebView.backgroundColor=[UIColor whiteColor];
    _detailWebView.scalesPageToFit=YES;
    _detailWebView.delegate=self;
    _detailWebView.opaque=NO;
    [self.view addSubview:_detailWebView];
    if (IS_iPhoneX) {
        [_detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(customNav.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(-84);
        }];
    }else{
        [_detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(customNav.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        }];
    }
    
    
    _bottomView = [[TopBlackLineView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    if (IS_iPhoneX) {
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(-34);
        }];
    }else{
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    
    _changeBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    _changeBT.layer.cornerRadius = 5;
    _changeBT.layer.masksToBounds = YES;
    [_bottomView addSubview:_changeBT];
    [_changeBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [FastAnimationAdd codeBindAnimation:_changeBT];
    
    [_changeBT addTarget:self action:@selector(checkChangeBT:) forControlEvents:UIControlEventTouchUpInside];
    [_changeBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    [_changeBT setTitle:@"兑 换" forState:UIControlStateNormal];
    _changeBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
    _changeBT.userInteractionEnabled = NO;
    //    if ([_stockNumber intValue] <= 0) {
    //        [_changeBT setTitle:@"库存不足" forState:UIControlStateNormal];
    //        _changeBT.userInteractionEnabled = NO;
    //        _changeBT.backgroundColor = [UIColor typefaceGrayColor];
    //    }
}

- (void)checkChangeBT:(UIButton *)sender
{
    [MobClick event:@"silver_goods_detail_exchange"];
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (!user) {
        [VCAppearManager presentLoginVCWithCurrentVC:self];
        return;
    }
    if (!isCanChange) {
        [SVProgressHUD showErrorWithStatus:_moreTimesStr];
        return;
    }
    
    if ([self.type intValue] == 1 || [self.type intValue] == 3) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"土豪,您要消耗%@两银子兑换\"%@\",是否继续",_consumeSilver,_nameStr] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self silverTraderChangeCodeSig];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if ([self.type intValue] == 2) {
        GoodsChangeVC *changeVC = [[GoodsChangeVC alloc] init];
        changeVC.consumeStr = _consumeSilver;
        changeVC.nameStr = _nameStr;
        changeVC.idStr = _idStr;
        [self.navigationController pushViewController:changeVC animated:YES];
    }
}

- (void)silverTraderChangeCodeSig
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]silverTraderChangePagecustomerId:user.customerId goodsId:_idStr name:nil cellphone:nil address:nil callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                [MobClick event:@"silver_goods_exchange_success"];
                [[SensorsAnalyticsSDK sharedInstance] track:@"GoodsExchange"
                                             withProperties:@{
                                                              @"GoodsName" : _nameStr,
                                                              @"CostSilver":@([_consumeSilver intValue]),
                                                              }];
                [self entranceRetrieveExchangePasswordVC];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"兑换失败!"];
        }
    }];
}

- (void)entranceRetrieveExchangePasswordVC {
    MySilverVC *clearVC = [[MySilverVC alloc] init];
    [self.navigationController pushViewController:clearVC animated:YES];
}

#pragma mark webViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request]) {
        return NO;
    }
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    self.requestString = [[request URL] absoluteString];
    DLog(@"获取路径====%@",_requestString);
    NSArray *components = [_requestString componentsSeparatedByString:@"*"];
    if ([components count] > 1)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginOfClick:) name:@"login_pwd_ensure_btn" object:nil];
        if (!user) {
            [_changeBT setTitle:@"去登录" forState:UIControlStateNormal];
            _changeBT.userInteractionEnabled = YES;
            _changeBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
        }
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appcallonloadhtml"] == NSOrderedSame && user)
        {
            [self achiveAccountData];
        }
        
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"getconditionfromjs"] == NSOrderedSame && user){
            NSString *messageStr = (NSString *)[components objectAtIndex:2];
            NSArray *codeArray = [messageStr componentsSeparatedByString:@"&"];
            
            if ([codeArray[0] intValue] == 2000) {
                [_changeBT setTitle:@"兑 换" forState:UIControlStateNormal];
                _changeBT.userInteractionEnabled = YES;
                _changeBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
            }else if ([codeArray[0] intValue] == 7011){
                _silverEnoughOrNot = @"0";
                [_changeBT setTitle:@"银子不足" forState:UIControlStateNormal];
                _changeBT.userInteractionEnabled = NO;
                _changeBT.backgroundColor = [UIColor typefaceGrayColor];
            }else if ([codeArray[0] intValue] == 7022){
                _conditionReachedstr = @"0";
                [_changeBT setTitle:@"未满足兑换条件" forState:UIControlStateNormal];
                _changeBT.userInteractionEnabled = NO;
                _changeBT.backgroundColor = [UIColor typefaceGrayColor];
            }else if ([codeArray[0] intValue] == 7021){
                isCanChange = NO;
                NSString *str = codeArray[1];
                _changeBT.userInteractionEnabled = YES;
                NSData *dataTitle = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSString *title = [[NSString alloc] initWithData:[GTMBase64 decodeData:dataTitle] encoding:NSUTF8StringEncoding];
                _moreTimesStr = title;
            }else if ([codeArray[0] intValue] == 7020){
                [_changeBT setTitle:@"库存不足" forState:UIControlStateNormal];
                _changeBT.userInteractionEnabled = NO;
                _changeBT.backgroundColor = [UIColor typefaceGrayColor];
            }
        }
        return NO;
    }
    return YES;
}

- (void)achiveAccountData
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser = obj;
            if (![user.silverNumber isEqualToString:resultUser.silverNumber]) {
                [IndividualInfoManage updateAccountWith:resultUser];
            }
            _silverNB = [NSString stringWithFormat:@"%@",resultUser.silverNumber];
            NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",user.customerId,_silverNB,_accessToken,user.cellphone,user.idcard,user.name,user.accountId];
            NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
            [self.detailWebView stringByEvaluatingJavaScriptFromString:onLoadStr];
        }
    }];
}

- (void)onLoginOfClick:(NSNotification *)sender
{
    if ([[SCMeasureDump shareSCMeasureDump].userOfObj isKindOfClass:[IndividualInfoManage class]])
    {
        IndividualInfoManage *resultUser = [SCMeasureDump shareSCMeasureDump].userOfObj;
        if (![[SCMeasureDump shareSCMeasureDump].userOfObj.silverNumber isEqualToString:resultUser.silverNumber])
        {
            [IndividualInfoManage updateAccountWith:resultUser];
        }
        _silverNB = [NSString stringWithFormat:@"%@",resultUser.silverNumber];
        _accessToken=[SCMeasureDump shareSCMeasureDump].accessTokenStr;
        NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",[SCMeasureDump shareSCMeasureDump].userOfObj.customerId,_silverNB,_accessToken,[SCMeasureDump shareSCMeasureDump].userOfObj.cellphone,[SCMeasureDump shareSCMeasureDump].userOfObj.idcard,[SCMeasureDump shareSCMeasureDump].userOfObj.name,[SCMeasureDump shareSCMeasureDump].userOfObj.accountId];
        NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
        [self.detailWebView stringByEvaluatingJavaScriptFromString:onLoadStr];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.detailWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.detailWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
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


