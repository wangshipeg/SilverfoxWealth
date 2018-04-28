//
//  CommitDrawalsInfoWebView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/7/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CommitDrawalsInfoWebView.h"
#import "DataRequest.h"
#import "SignHelper.h"
#import "CommunalInfo.h"
#import "ExchangeDetailVC.h"
#import <SVProgressHUD.h>
#import "SCMeasureDump.h"

@interface CommitDrawalsInfoWebView ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *signStr;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation CommitDrawalsInfoWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"提现";
    self.title = @"提现";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@payments/withdraw/html",LOCAL_HOST]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request]) {
        return NO;
    }
    NSString *requestString = [[request URL] absoluteString];
    DLog(@"获取请求路径= = ==%@",requestString);
    NSArray *components = [requestString componentsSeparatedByString:@"*"];
    if ([components count] > 1)
    {
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callappmyassert"] == NSOrderedSame)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        return NO;
    }
    
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSDictionary *requestHeaders = request.allHTTPHeaderFields;
    if (requestHeaders[@"customerId"]) {
        return YES;
    } else {
        [self achieveSign];
        [mutableRequest setValue:user.accountId forHTTPHeaderField:@"accountId"];
        [mutableRequest setValue:user.customerId forHTTPHeaderField:@"customerId"];
        [mutableRequest setValue:@"000001" forHTTPHeaderField:@"channel"];
        [mutableRequest setValue:_cardNO forHTTPHeaderField:@"cardNO"];
        [mutableRequest setValue:_provinceBankNO forHTTPHeaderField:@"provinceBankNO"];
        [mutableRequest setValue:_principal forHTTPHeaderField:@"principal"];
        [mutableRequest setValue:_signStr forHTTPHeaderField:@"sign"];
        [mutableRequest setValue:@"2" forHTTPHeaderField:@"detailChannel"];
        [mutableRequest setValue:@"1" forHTTPHeaderField:@"category"];
        request = [mutableRequest copy];
        [webView loadRequest:request];
        return NO;
    }
    return YES;
}

#pragma mark-----签名*
- (void)achieveSign {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    NSString *customerId = user.customerId;
    NSString *accountId = user.accountId;
    NSString *cardNO = _cardNO;
    NSString *provinceBankNO = _provinceBankNO;
    NSString *principal = _principal;
    NSString *channel = @"000001";
    NSString *detailChannel = @"2";
    NSString *sign_type = @"MD5";
    NSDictionary *signDic=NSDictionaryOfVariableBindings(customerId,accountId,cardNO,provinceBankNO,principal,channel,detailChannel,sign_type);
    _signStr = [SignHelper  partnerSignOrder:signDic sig:[SCMeasureDump shareSCMeasureDump].signString];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated
{
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

