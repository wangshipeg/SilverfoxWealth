//
//  CommitBuyInfoWebview.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/7/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CommitBuyInfoWebview.h"
#import "DataRequest.h"
#import "SignHelper.h"
#import "CommunalInfo.h"
#import <SVProgressHUD.h>
#import "AddCancelButton.h"
#import "SCMeasureDump.h"
#import "RechargeVC.h"
#import "GTMBase64.h"
#import "ShareView.h"
#import "ShareConfig.h"

@interface CommitBuyInfoWebview ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *signStr;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@property (nonatomic, strong) ShareView *shareView;

@end

@implementation CommitBuyInfoWebview

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"购买";
    self.title = @"购买";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    weakSelf.customNav.leftViewController = ^{
        [weakSelf accessFirstVC];
    };
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    self.webView.opaque = NO;
    [self.view addSubview:self.webView];
    if (IS_iPhoneX) {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.customNav.mas_bottom);
             make.left.equalTo(self.view.mas_left);
             make.right.equalTo(self.view.mas_right);
             make.bottom.equalTo(self.view.mas_bottom).offset(-34);
         }];
    }else{
        [_webView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.customNav.mas_bottom);
             make.left.equalTo(self.view.mas_left);
             make.right.equalTo(self.view.mas_right);
             make.bottom.equalTo(self.view.mas_bottom);
         }];
    }
    
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@product/buy",LOCAL_HOST]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    NSString *body = [NSString stringWithFormat:@"customerId=%@&productId=%@",user.customerId,self.productId];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [_webView loadRequest: request];
}

- (void)accessFirstVC
{
    if (self.webView.canGoBack)
    {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    //[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    DLog(@"购买成功获取请求路径====%@",requestString);
    NSArray *components = [requestString componentsSeparatedByString:@"*"];
    if ([components count] > 1)
    {
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callappmyassert"] == NSOrderedSame)
        {
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            [control setSelectedIndex:3];
        }
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppRecharge"] == NSOrderedSame)
        {
            RechargeVC *rechargeVC = [[RechargeVC alloc] init];
            rechargeVC.fromStr = @"buy";
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"showopenaccount"] == NSOrderedSame)
        {
            [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
        }
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallOnloadHtml"] == NSOrderedSame && user)
        {
            [self achiveAccountWithData:user];
        }
        
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"htmlcallappshare"] == NSOrderedSame)
        {
            NSString *message = (NSString *)[components objectAtIndex:2];
            NSArray *contents = [message componentsSeparatedByString:@"&"];
            DLog(@"contents====%@",contents);
            //分享内容
            NSString *contentStr = (NSString *)[contents objectAtIndex:2];
            NSString *content = [contentStr substringFromIndex:8];
            NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
            NSString *CStr = [[NSString alloc] initWithData:[GTMBase64 decodeData:data] encoding:NSUTF8StringEncoding];
            //分享图片
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)[contents objectAtIndex:1]]]];
            //分享标题
            NSString *titleOfBase = (NSString *)[contents objectAtIndex:0];
            NSString *titleOB = [titleOfBase substringFromIndex:6];
            NSData *dataTitle = [titleOB dataUsingEncoding:NSUTF8StringEncoding];
            NSString *title=[[NSString alloc] initWithData:[GTMBase64 decodeData:dataTitle] encoding:NSUTF8StringEncoding];
            if (!_shareView)
            {
                _shareView = [[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:2];
            }
            IndividualInfoManage *user=[IndividualInfoManage currentAccount];
            NSString *urlStr=(NSString *)[contents objectAtIndex:3];
            NSString *userUrlStr = [urlStr substringFromIndex:4];
            [_shareView show:^(NSInteger PlatformTag) {
                if (PlatformTag == 0) {
                    [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:[NSString stringWithFormat:@"%@,%@",CStr,userUrlStr] shareImage:image title:title userUrlStr:userUrlStr succeedCallback:^{
                        NSString *shareSuccess = [NSString stringWithFormat:@"checkIsAppShareSuccess('share_success')"];
                        [self.webView stringByEvaluatingJavaScriptFromString:shareSuccess];
                    }];
                } else {
                    [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:CStr shareImage:image title:title userUrlStr:userUrlStr succeedCallback:^{
                        NSString *shareSuccess = [NSString stringWithFormat:@"checkIsAppShareSuccess('share_success')"];
                        [self.webView stringByEvaluatingJavaScriptFromString:shareSuccess];
                    }];
                }
            }];
        }
        
        return NO;
    }
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request]) {
        return NO;
    }
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    return YES;
}

- (void)achiveAccountWithData:(IndividualInfoManage *)user
{
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]])
        {
            IndividualInfoManage *resultUser = obj;
            if (![user.silverNumber isEqualToString:resultUser.silverNumber])
            {
                [IndividualInfoManage updateAccountWith:resultUser];
            }
            NSString *silverNB = [NSString stringWithFormat:@"%@",resultUser.silverNumber];
            NSString *accessToken=[SCMeasureDump shareSCMeasureDump].accessTokenStr;
            NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",user.customerId,silverNB,accessToken,user.cellphone,user.idcard,user.name,user.accountId];
            NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
            [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];
        }
    }];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
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

