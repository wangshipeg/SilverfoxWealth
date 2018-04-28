//
//  SetUpTradePasswordWebView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/7/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SetUpTradePasswordWebView.h"
#import "DataRequest.h"
#import "SignHelper.h"
#import "CommunalInfo.h"
#import <SVProgressHUD.h>
#import "OpenAccountSuccessView.h"
#import "StringHelper.h"
#import "SCMeasureDump.h"
#import "DataRequest.h"
#import "UMMobClick/MobClick.h"

@interface SetUpTradePasswordWebView ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *signStr;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation SetUpTradePasswordWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"设置交易密码";
    self.title = @"设置交易密码";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    weakSelf.customNav.leftViewController = ^{
        if ([[SCMeasureDump shareSCMeasureDump].openAccountPresentVC isEqualToString:@"openAccountVC"]) {
            [weakSelf.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [weakSelf.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
        }
    };
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.customNav.mas_bottom);
         make.left.equalTo(self.view.mas_left);
         make.right.equalTo(self.view.mas_right);
         make.bottom.equalTo(self.view.mas_bottom);
     }];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@customers/trade/password/set/html",LOCAL_HOST]];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"jump_set_trade_password"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request]) {
        return NO;
    }
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    NSString *urlString = [[request URL]  absoluteString];
    NSArray *components = [urlString componentsSeparatedByString:@"*"];
    if ([components count] > 1)
    {
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"showopenaccount"] == NSOrderedSame)
        {
            [[DataRequest sharedClient] requestWhetherSetUpTradePasswordAccountId:user.accountId callback:^(id obj) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    if ([obj[@"pinFlag"] intValue] == 1) {
                        if ([[SCMeasureDump shareSCMeasureDump].openAccountPresentVC isEqualToString:@"openAccountVC"]) {
                            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                            [self addOpenAccountView:user];
                        } else {
                            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                            [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
                        }
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"设置失败"];
                    }
                }
            }];
        }
        return NO;
    }
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSDictionary *requestHeaders = request.allHTTPHeaderFields;
    // 判断请求头是否已包含，如果不判断该字段会导致webview加载时死循环
    if (requestHeaders[@"idcard"] && requestHeaders[@"accountId"]) {
        return YES;
    } else {
        [mutableRequest setValue:user.accountId forHTTPHeaderField:@"accountId"];
        [mutableRequest setValue:user.idcard forHTTPHeaderField:@"idcard"];
        [mutableRequest setValue:@"000001" forHTTPHeaderField:@"channel"];
        [mutableRequest setValue:user.cellphone forHTTPHeaderField:@"cellphone"];
        [mutableRequest setValue:@"1" forHTTPHeaderField:@"category"];
        request = [mutableRequest copy];
        [webView loadRequest:request];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [SVProgressHUD dismiss];
}


//添加开户成功弹框
- (void)addOpenAccountView:(IndividualInfoManage *)user {
    OpenAccountSuccessView *successView = [[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:6];
    successView.nameLB.text = [StringHelper coverUserNameWith:user.name];
    successView.accountIdLB.text = user.accountId;
    [successView showOpenAccountSuccessView];
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

