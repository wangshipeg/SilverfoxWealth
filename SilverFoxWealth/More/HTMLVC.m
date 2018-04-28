

#import "HTMLVC.h"
#import "CommunalInfo.h"
#import "SCMeasureDump.h"
#import "GTMBase64.h"
#import "ShareView.h"
#import "ShareConfig.h"
#import "DataRequest.h"
#import "EncryptHelper.h"
#import "SVProgressHUD.h"
#import "AddCancelButton.h"

@interface HTMLVC ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *announceWebView;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *urlStrOfNew;//2.0版本之后改接口头 为  m
@property (nonatomic, strong) NSString *requestString;
@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) NSString *silverNB;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation HTMLVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf back];
    };
    
    self.announceWebView=[[UIWebView alloc] init];
    self.announceWebView.scalesPageToFit=NO;
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
    }else{
        [_announceWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.customNav.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    
    if (_work == frequentQuestion)
    {
        self.urlStr = @"faqs";
        _customNav.titleLabel.text = @"常见问题";
        self.title = @"常见问题";
    }
    
    if (_work == rebateUseInfo)
    {
        self.urlStr=@"coupon/description";
        _customNav.titleLabel.text=@"优惠券说明";
        self.title = @"优惠券说明";
    }
    
    if (_work == silverUseInfo)
    {
        self.urlStr = @"silver/intro";
        _customNav.titleLabel.text = @"银子说明";
        self.title = @"银子说明";
    }
    
    if (_work == limitInfo)
    {
        self.urlStr = @"bank/limit";
        _customNav.titleLabel.text = @"限额说明";
        self.title = @"限额说明";
    }
    
    if (_work == accountServiceAgreement)
    {
        self.urlStr = [NSString stringWithFormat:@"service/agreement"];
        _customNav.titleLabel.text = @"服务协议";
        self.title = @"服务协议";
    }
    if (_work == openAccount)
    {
        self.urlStr = [NSString stringWithFormat:@"account/protocol"];
        _customNav.titleLabel.text = @"详情";
    }
    if (_work == userPersonal)
    {
        self.urlStr = [NSString stringWithFormat:@"three/party/protocol"];
        _customNav.titleLabel.text = @"详情";
    }
    
    if (_urlStr) {
        NSString *urlStr=[NSString stringWithFormat:@"%@%@",LOCAL_HOST,_urlStr];
        NSURL *url=[NSURL URLWithString:urlStr];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.announceWebView loadRequest:request];
    }else{
        NSString *questionnaireStr=[NSString stringWithFormat:@"%@",_questionnaire];
        NSURL *urlS=[NSURL URLWithString:questionnaireStr];
        DLog(@"url==%@",urlS);
        _customNav.titleLabel.text = @"调查问卷";
        self.title = @"调查问卷";
        NSURLRequest *requestStr=[[NSURLRequest alloc] initWithURL:urlS];
        [self.announceWebView loadRequest:requestStr];
    }
}
- (void)back{
    if (self.announceWebView.canGoBack) {
        [self.announceWebView goBack];
    }else{
        //点击返回按钮  返回到之前页面
        [self.navigationController popViewControllerAnimated:YES];
        if (self.work == accountServiceAgreement) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request]) {
        return NO;
    }
    self.requestString = [[request URL] absoluteString];//获取请求的绝对路径.
    DLog(@"获取请求路径====%@",_requestString);
    NSArray *components = [_requestString componentsSeparatedByString:@"*"];//提交请求时候分割参数的分隔符
    if ([components count] > 1) {
        //过滤请求是否是我们需要的.不需要的请求不进入条件
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"htmlcallappshare"] == NSOrderedSame)
        {
            NSString *message = (NSString *)[components objectAtIndex:2];
            NSArray *contents = [message componentsSeparatedByString:@"&"];
            //base64解码  分享内容
            NSString *contentStr = (NSString *)[contents objectAtIndex:2];
            //给定一个位置，从此位置一直截取到字符串结束
            NSString *content = [contentStr substringFromIndex:8];
            NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
            NSString *CStr=[[NSString alloc] initWithData:[GTMBase64 decodeData:data] encoding:NSUTF8StringEncoding];
            //分享图片
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)[contents objectAtIndex:1]]]];
            //base64解码  分享标题
            NSString *titleOfBase = (NSString *)[contents objectAtIndex:0];
            //给定一个位置，从此位置一直截取到字符串结束
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
        return NO;
    }
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    
    [self.announceWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.announceWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    //调用html页面的js方法
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser = obj;
            if (![user.silverNumber isEqualToString:resultUser.silverNumber]) {
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


@end

