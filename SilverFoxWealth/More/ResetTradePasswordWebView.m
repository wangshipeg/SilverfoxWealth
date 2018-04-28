

#import "ResetTradePasswordWebView.h"
#import "DataRequest.h"
#import "SignHelper.h"
#import "CommunalInfo.h"
#import <SVProgressHUD.h>
#import "StringHelper.h"
#import "DataRequest.h"

@interface ResetTradePasswordWebView ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *signStr;
@end

@implementation ResetTradePasswordWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"修改交易密码";
    self.title = @"修改交易密码";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf accessFirstVC];
    };
    
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(customNav.mas_bottom);
         make.left.equalTo(self.view.mas_left);
         make.right.equalTo(self.view.mas_right);
         make.bottom.equalTo(self.view.mas_bottom);
     }];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@customers/trade/password/reset/html/%@/%@/000001/%@/1",LOCAL_HOST,user.accountId,user.cellphone,user.idcard]];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)accessFirstVC
{
    [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request]) {
        return NO;
    }
    NSString *urlString = [[request URL]  absoluteString];
    NSArray *components = [urlString componentsSeparatedByString:@"*"];//提交请求时候分割参数的分隔符
    //前提是已经登陆
    if ([components count] > 1)
    {
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"showopenaccount"] == NSOrderedSame)
        {
            [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
        }
        return NO;
    }
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
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





@end

