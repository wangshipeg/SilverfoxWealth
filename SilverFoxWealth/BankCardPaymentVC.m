//
//  BankCardPaymentVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BankCardPaymentVC.h"
#import "CommunalInfo.h"
#import <SVProgressHUD.h>
#import "IndividualInfoManage.h"
#import "DataRequest.h"
#import "RequestOAth.h"
#import "SCMeasureDump.h"

@interface BankCardPaymentVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation BankCardPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    if (IS_iPhoneX) {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.view.mas_top);
             make.left.equalTo(self.view.mas_left);
             make.right.equalTo(self.view.mas_right);
             make.bottom.equalTo(self.view.mas_bottom).offset(-140);
         }];
    }else{
        [_webView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.view.mas_top);
             make.left.equalTo(self.view.mas_left);
             make.right.equalTo(self.view.mas_right);
             make.bottom.equalTo(self.view.mas_bottom).offset(-114);
         }];
    }
    NSString *urlStr=[NSString stringWithFormat:@"%@payments/recharge/offline",LOCAL_HOST];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    [self.webView reload];

    // Do any additional setup after loading the view.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request]) {
        return NO;
    }
    NSString *requestString = [[request URL] absoluteString];//获取请求的绝对路径.
    DLog(@"获取请求路径====%@",requestString);
    NSArray *components = [requestString componentsSeparatedByString:@"*"];//提交请求时候分割参数的分隔符
    //前提是已经登陆
    if ([components count] > 1)
    {
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"copyBankNo"] == NSOrderedSame)
        {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            [pab setString:components[2]];
            if (pab == nil) {
                [SVProgressHUD showErrorWithStatus:@"复制失败"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"复制成功"];
            }
        }
        
        //进入界面 先执行此方法获取用户信息
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallOnloadHtml"] == NSOrderedSame)
        {
            // 在这里做js调native的事情
            [self achiveAccountWithData];
        }
        return NO;
    }
    return YES; // 继续对本次请求进行导航
}

- (void)achiveAccountWithData
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        DLog(@"获取投资客信息===%@",obj);
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser = obj;
            if (![user.silverNumber isEqualToString:resultUser.silverNumber]) {
                [IndividualInfoManage updateAccountWith:resultUser];
            }
            NSString *silverNB = [NSString stringWithFormat:@"%@",resultUser.silverNumber];
            
            NSString *accessToken = [SCMeasureDump shareSCMeasureDump].accessTokenStr;
            NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",user.customerId,silverNB,accessToken,user.cellphone,user.idcard,user.name,user.accountId];
            NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
            [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];
        }
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
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
