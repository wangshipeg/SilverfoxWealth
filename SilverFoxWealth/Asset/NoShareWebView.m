//
//  NoShareWebView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/5/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NoShareWebView.h"
#import "SVProgressHUD.h"

@interface NoShareWebView ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation NoShareWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"详情";
    [self.view addSubview:customNav];
    __weak typeof(self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    if (IS_iPhoneX) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, iPhoneX_Navigition_Bar_Height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - iPhoneX_Navigition_Bar_Height)];
    }else{
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    }
    self.webView.navigationDelegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    [self.view addSubview:_webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
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

