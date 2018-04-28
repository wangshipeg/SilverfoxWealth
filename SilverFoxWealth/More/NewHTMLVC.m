//
//  NewHTMLVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NewHTMLVC.h"
#import "CommunalInfo.h"
#import "SCMeasureDump.h"
#import "ProductVC.h"
#import "ProductDetailVC.h"
#import "ProductVC.h"
#import "SilverTraderVC.h"
#import "SilverDetailPageVC.h"
#import "MyBonusVC.h"
#import "VCAppearManager.h"
#import "GTMBase64.h"
#import "ShareView.h"
#import "ShareConfig.h"
#import "DataRequest.h"
#import "ProductVC.h"
#import "ProductDetailVC.h"
#import "ProductVC.h"
#import "SilverTraderVC.h"
#import "SilverDetailPageVC.h"
#import "MyBonusVC.h"
#import "MyAssetVC.h"
#import "WithoutAuthorization.h"
#import "UIBarButtonItem+SXCreate.h"
#import "SIgnInVC.h"

@interface NewHTMLVC ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *announceWebView;
@property (nonatomic, strong) NSString *urlStrOfNew;
@property (nonatomic, strong) NSString *requestString;
@property (nonatomic, strong)  NSString *silverNB;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation NewHTMLVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    _customNav.leftViewController = ^{
        if (weakSelf.announceWebView.canGoBack) {
            [weakSelf.announceWebView goBack];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    self.announceWebView=[[UIWebView alloc] init];
    self.announceWebView.scalesPageToFit = YES;
    self.announceWebView.scrollView.bounces = NO;
    self.announceWebView.delegate = self;
    [self.view addSubview:self.announceWebView];
    if (IS_iPhoneX) {
        [_announceWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.customNav.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(-34);
        }];
    } else {
        [_announceWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.customNav.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    
    if (_work == serveProtocol) {
        self.productOfID = [SCMeasureDump shareSCMeasureDump].productHD;
        self.urlStrOfNew = [NSString stringWithFormat:@"product/protocol?protocolId=%@",_productOfID];
        _customNav.titleLabel.text=@"详情";
    }
    if (_work == serveProtocolTwo) {
        self.productOfID = [SCMeasureDump shareSCMeasureDump].productHDTwo;
        self.urlStrOfNew = [NSString stringWithFormat:@"product/protocol?protocolId=%@",_productOfID];
        _customNav.titleLabel.text=@"详情";
    }
    if (_work == serveProtocolThree) {
        self.productOfID = [SCMeasureDump shareSCMeasureDump].productHDThree;
        self.urlStrOfNew = [NSString stringWithFormat:@"product/protocol?protocolId=%@",_productOfID];
        _customNav.titleLabel.text=@"详情";
    }
    
    if (_work == invitorFriend)
    {
        self.urlStrOfNew = [NSString stringWithFormat:@"invitation"];
        _customNav.titleLabel.text = @"邀请好友";
        self.title = @"邀请好友";
    }
    
    if (_work==productAdPage) {
        self.productOfID = [SCMeasureDump shareSCMeasureDump].productListId;
        self.urlStrOfNew=[NSString stringWithFormat:@"banner/detail?bannerId=%@",_productOfID];
        _customNav.titleLabel.text=@"详情";
    }
    if (_work==noviceGuide) {
        self.urlStrOfNew=[NSString stringWithFormat:@"activities/guide"];
        _customNav.titleLabel.text=@"新手指引";
        self.title = @"新手指引";
    }
    
    if (_work==signinRule) {
        self.urlStrOfNew=[NSString stringWithFormat:@"signin/rule"];
        _customNav.titleLabel.text=@"签到规则";
        self.title = @"签到规则";
    }
    
    if (_work == safeEnsure)
    {
        self.urlStrOfNew = @"information";
        _customNav.titleLabel.text = @"信息披露";
        self.title = @"信息披露";
    }
    
    if (_work == LuckDraw) {
        self.urlStrOfNew = [NSString stringWithFormat:@"silver/mall/lottery"];
        _customNav.titleLabel.text = @"抽奖";
        self.title = @"抽奖";
    }
    
    if (_work == myFinancing) {
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        self.urlStrOfNew = [NSString stringWithFormat:@"customer/timer/shaft/%@",user.customerId];
        _customNav.titleLabel.text = @"理财历程";
        self.title = @"理财历程";
    }
    
    if (_work == MemberWithdrawals) {
        self.urlStrOfNew = [NSString stringWithFormat:@"member/withdrawals"];
        _customNav.titleLabel.text = @"提现次数";
        self.title = @"提现次数";
    }
    
    if (_work == MemberBirthday) {
        self.urlStrOfNew = [NSString stringWithFormat:@"member/birthday"];
        _customNav.titleLabel.text = @"生日福利";
        self.title = @"生日福利";
    }
    
    if (_work == MemberCoupon) {
        self.urlStrOfNew = [NSString stringWithFormat:@"member/coupon"];
        _customNav.titleLabel.text = @"专属优惠券";
        self.title = @"专属优惠券";
    }
    if (_work == MemberAdviser) {
        self.urlStrOfNew = [NSString stringWithFormat:@"activities/vip/adviser"];
        _customNav.titleLabel.text = @"专属理财顾问";
        self.title = @"专属理财顾问";
    }
    
    if (_work == MemberPatch_card) {
        self.urlStrOfNew = [NSString stringWithFormat:@"activities/vip/patchCard"];
        _customNav.titleLabel.text = @"补签卡";
        self.title = @"补签卡";
    }
    
    if (_work == MemberDiscount) {
        self.urlStrOfNew = [NSString stringWithFormat:@"activities/vip/silverDiscount"];
        _customNav.titleLabel.text = @"银子商城折扣";
        self.title = @"银子商城折扣";
    }
    if (_work == MemberInterest) {
        self.urlStrOfNew = [NSString stringWithFormat:@"activities/vip/addRate"];
        _customNav.titleLabel.text = @"专属加息";
        self.title = @"专属加息";
    }
    
    if (_work == MemberBill) {
        self.urlStrOfNew = [NSString stringWithFormat:@"member/bill"];
        _customNav.titleLabel.text = @"月度账单";
        self.title = @"月度账单";
    }
    if (_work == MemberLevelInstructions) {
        self.urlStrOfNew = [NSString stringWithFormat:@"activities/vip/vipRule"];
        _customNav.titleLabel.text = @"等级说明";
        self.title = @"等级说明";
    }

    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",LOCAL_HOST,_urlStrOfNew];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [self.announceWebView loadRequest:request];
    
    if (_work == productAdContent) {
        NSString *newUrlStr =[NSString stringWithFormat:@"%@",[SCMeasureDump shareSCMeasureDump].productListId];
        _customNav.titleLabel.text=@"详情";
        NSString *urlStr=[NSString stringWithFormat:@"%@",newUrlStr];
        NSURL *url=[NSURL URLWithString:urlStr];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.announceWebView loadRequest:request];
        return;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request]) {
        return NO;
    }
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    self.requestString = [[request URL] absoluteString];
    DLog(@"获取请求路径====%@",_requestString);
    NSArray *components = [_requestString componentsSeparatedByString:@"*"];
    if ([components count] > 1)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginOfClick:) name:@"login_pwd_ensure_btn" object:nil];
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"htmlcallappshare"] == NSOrderedSame && !user){
            [self noLogin];
        }
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"htmlcallappshare"] == NSOrderedSame && user)
        {
            NSString *message = (NSString *)[components objectAtIndex:2];
            NSArray *contents = [message componentsSeparatedByString:@"&"];
            //分享内容
            NSString *contentStr = (NSString *)[contents objectAtIndex:2];
            NSString *content = [contentStr substringFromIndex:8];
            NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
            NSString *CStr=[[NSString alloc] initWithData:[GTMBase64 decodeData:data] encoding:NSUTF8StringEncoding];
            //分享图片
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)[contents objectAtIndex:1]]]];
            //base64解码  分享标题
            NSString *titleOfBase = (NSString *)[contents objectAtIndex:0];
            NSString *titleOB = [titleOfBase substringFromIndex:6];
            NSData *dataTitle=[titleOB dataUsingEncoding:NSUTF8StringEncoding];
            NSString *title=[[NSString alloc] initWithData:[GTMBase64 decodeData:dataTitle] encoding:NSUTF8StringEncoding];
            if (!_shareView)
            {
                _shareView=[[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:2];
            }
            IndividualInfoManage *user=[IndividualInfoManage currentAccount];
            NSString *urlStr=(NSString *)[contents objectAtIndex:3];
            NSString *userUrlStr = [urlStr substringFromIndex:4];
            [_shareView show:^(NSInteger PlatformTag) {
                if (PlatformTag == 0) {
                    [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:CStr shareImage:image title:title userUrlStr:userUrlStr succeedCallback:^{
                        NSString *shareSuccess = [NSString stringWithFormat:@"checkIsAppShareSuccess('share_success')"];
                        [self.announceWebView stringByEvaluatingJavaScriptFromString:shareSuccess];
                    }];
                } else {
                    NSLog(@"分享内容=====%@",CStr);
                    [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:CStr shareImage:image title:title userUrlStr:userUrlStr succeedCallback:^{
                        //分享成功回调
                        [self.announceWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"checkIsAppShareSuccess('share_success')"]];
                        DLog(@"分享成功");
                    }];
                }
            }];
        }
        
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallHtml"] == NSOrderedSame && !user)
        {
            [self noLogin];
        }
        
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallHtml"] == NSOrderedSame && user)
        {
            // 在这里做js调native的事情
            [self achiveAccountData:user];
        }
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"goAppSignRecordPage"] == NSOrderedSame && user)
        {
            // 跳转签到
            SIgnInVC *sign = [[SIgnInVC alloc] init];
            [self.navigationController pushViewController:sign animated:YES];
        }
        
#pragma -mark 跳转到我的资产(需参数productId)
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppMyAssert"] == NSOrderedSame && !user)
        {
            NSString *isClose = (NSString *)[components objectAtIndex:2];
            if ([isClose intValue] == 1) {
                [self noDataLogin];
            }else{
                [self noLogin];
            }
        }
        
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppMyAssert"] == NSOrderedSame && user)
        {
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            [control setSelectedIndex:3];
        }
        
#pragma -mark 跳转到产品详情页(需参数productId)
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppProductDetail"] == NSOrderedSame)
        {
            NSString *strArr = (NSString *)[components objectAtIndex:2];
            NSArray *contents = [strArr componentsSeparatedByString:@"&"];
            NSString *productId = (NSString *)[contents objectAtIndex:0];
            
            NSString *isClose = (NSString *)[contents objectAtIndex:1];
            
            ProductDetailVC *productDetailVC = [[ProductDetailVC alloc] init];
            productDetailVC.productId = productId;
            
            if ([isClose intValue] == 1) {
                
                [self pushToRootVC:productDetailVC];
            }
            
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }
        
#pragma -mark 跳转到产品列表页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppProductList"] == NSOrderedSame)
        {
            NSString *isClose = (NSString *)[components objectAtIndex:2];
            ProductVC *productVC = [[ProductVC alloc] init];
            if ([isClose intValue] == 1) {
                [self pushToRootVC:productVC];
            }
            [self.navigationController pushViewController:productVC animated:YES];
        }
#pragma -mark 跳转到银子商城列表页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppSilverStoreList"] == NSOrderedSame)
        {
            NSString *isClose = (NSString *)[components objectAtIndex:2];
            SilverTraderVC *productDetailVC = [[SilverTraderVC alloc] init];
            if ([isClose intValue] == 1) {
                [self pushToRootVC:productDetailVC];
            }
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }
#pragma -mark 跳转到银子商城详情页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppSilverStoreDetail"] == NSOrderedSame && !user)
        {
            NSString *isClose = (NSString *)[components objectAtIndex:2];
            if ([[SCMeasureDump shareSCMeasureDump].silverGoodsImageBack isEqualToString:@"100"]) {
                SilverTraderVC *silverTrader = [[SilverTraderVC alloc] init];
                [self.navigationController popToViewController:silverTrader animated:YES];
            }else if ([isClose intValue] == 1) {
                [self noDataLogin];
            }else{
                [self noLogin];
            }
        }
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppSilverStoreDetail"] == NSOrderedSame && user)
        {
            
            NSString *message = (NSString *)[components objectAtIndex:2];
            NSArray *contents = [message componentsSeparatedByString:@"&"];
            DLog(@"contents====%@",contents);
            NSString *idStr = (NSString *)[contents objectAtIndex:0];
            NSString *typeStr = (NSString *)[contents objectAtIndex:2];
            NSString *silverStr = (NSString *)[contents objectAtIndex:3];
            NSString *isClose = (NSString *)[contents objectAtIndex:4];
            SilverDetailPageVC *productDetailVC = [[SilverDetailPageVC alloc] init];
            productDetailVC.idStr = idStr;
            productDetailVC.type = typeStr;
            productDetailVC.consumeSilver = silverStr;
            productDetailVC.nameStr = @"详情";
            if ([isClose intValue] == 1) {
                [self pushToRootVC:productDetailVC];
            }
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }
#pragma -mark 跳转到我的优惠券页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppMyCouponList"] == NSOrderedSame && !user)
        {
//            NSString *isClose = (NSString *)[components objectAtIndex:2];
//            if ([isClose intValue] == 1) {
//                [self noDataLogin];
//            }else{
//                [self noLogin];
//            }
            [self noLogin];
        }
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppMyCouponList"] == NSOrderedSame && user)
        {
            NSString *isClose = (NSString *)[components objectAtIndex:2];
            MyBonusVC *myBonusVC = [[MyBonusVC alloc] init];
            if ([isClose intValue] == 1) {
                [self pushToRootVC:myBonusVC];
            }
            [self.navigationController pushViewController:myBonusVC animated:YES];
        }
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appcallonloadhtml"] == NSOrderedSame && user)
        {
            // 在这里做js调native的事情
            [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
                if ([obj isKindOfClass:[IndividualInfoManage class]])
                {
                    IndividualInfoManage *resultUser = obj;
                    if (![user.silverNumber isEqualToString:resultUser.silverNumber])
                    {
                        [IndividualInfoManage updateAccountWith:resultUser];
                    }
                    _silverNB = [NSString stringWithFormat:@"%@",resultUser.silverNumber];
                    _accessToken=[SCMeasureDump shareSCMeasureDump].accessTokenStr;
                    NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",user.customerId,_silverNB,_accessToken,user.cellphone,user.idcard,user.name,user.accountId];
                    NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
                    [self.announceWebView stringByEvaluatingJavaScriptFromString:onLoadStr];
                }
            }];
        }
        return NO;
    }
    return YES;
}

- (void)achiveAccountData:(IndividualInfoManage *)user
{
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        DLog(@"获取投资客信息===%@",obj);
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser = obj;
            if (![user.silverNumber isEqualToString:resultUser.silverNumber]) {
                [IndividualInfoManage updateAccountWith:resultUser];
            }
            _silverNB = [NSString stringWithFormat:@"%@",resultUser.silverNumber];
            _accessToken = [SCMeasureDump shareSCMeasureDump].accessTokenStr;
            NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",user.customerId,_silverNB,_accessToken,user.cellphone,user.idcard,user.name,user.accountId];
            NSString *onLoadStr = [NSString stringWithFormat:@"checkFromApp('%@')",str];
            [self.announceWebView stringByEvaluatingJavaScriptFromString:onLoadStr];
        }
    }];
}

- (void)pushToRootVC:(UIViewController*)vc
{
    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToRootVC:) image:[UIImage imageNamed:@"nav_back.png"]];
}

- (void)onLoginOfClick:(NSNotification *)sender
{
    NSString *onLoadStr2 = [NSString stringWithFormat:@"appLoginSuccess('login_success')"];
    [self.announceWebView stringByEvaluatingJavaScriptFromString:onLoadStr2];
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
        [self.announceWebView stringByEvaluatingJavaScriptFromString:onLoadStr];
    }
}

- (void)backToRootVC:(UIButton *)sender
{
    if ([[SCMeasureDump shareSCMeasureDump].silverGoodsImageBack isEqualToString:@"100"]) {
        UIViewController *target = nil;
        for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
            if ([controller isKindOfClass:[SilverTraderVC class]]) {
                target = controller;
            }
        }
        if (target) {
            [self.navigationController popToViewController:target animated:YES];
        }
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)noLogin
{
    [VCAppearManager presentLoginVCWithCurrentVC:self];
}

- (void)noDataLogin
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [VCAppearManager presentLoginVCWithCurrentVC:self];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    [self.announceWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.announceWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    //调用html页面的js方法
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]])
        {
            IndividualInfoManage *resultUser = obj;
            if (![user.silverNumber isEqualToString:resultUser.silverNumber])
            {
                [IndividualInfoManage updateAccountWith:resultUser];
            }
            _silverNB = [NSString stringWithFormat:@"%@",resultUser.silverNumber];
            _accessToken=[SCMeasureDump shareSCMeasureDump].accessTokenStr;
            NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",user.customerId,_silverNB,_accessToken,user.cellphone,user.idcard,user.name,user.accountId];
            NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
            [self.announceWebView stringByEvaluatingJavaScriptFromString:onLoadStr];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

