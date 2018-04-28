

#import "ActivityZoonWebView.h"
#import "CommunalInfo.h"
#import "ShareView.h"
#import "ShareConfig.h"
#import "DataRequest.h"
#import "GTMBase64.h"
#import "SCMeasureDump.h"
#import "ProductDetailVC.h"
#import "ProductVC.h"
#import "SilverTraderVC.h"
#import "SilverDetailPageVC.h"
#import "MyBonusVC.h"
#import "VCAppearManager.h"

@interface ActivityZoonWebView ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) NSString *requestString;
@property (nonatomic, strong) NSString *silverNB;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation ActivityZoonWebView

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"详情";
    [_customNav.rightButton setImage:[UIImage imageNamed:@"Share.png"] forState:UIControlStateNormal];
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    weakSelf.customNav.leftViewController = ^{
        [weakSelf backView];
    };
    weakSelf.customNav.rightButtonHandle = ^{
        [weakSelf shareTo];
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
    
    if ([_model.type integerValue] == 1)
    {
        _urlStr=[NSString stringWithFormat:@"%@",self.model.content];
        NSURL *url=[NSURL URLWithString:_urlStr];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
        [self.webView reload];
    }
    if ([self.model.type integerValue] == 2)
    {
        _urlStr=[NSString stringWithFormat:@"%@activities/detail?%@",LOCAL_HOST,self.model.idStr];
        NSURL *url=[NSURL URLWithString:_urlStr];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (void)shareTo {
    if (!_shareView) {
        _shareView = [[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:2];
    }
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    NSString *shareStr=[NSString stringWithFormat:@"%@",self.model.shareDesc];
    NSString *userUrlStr=[NSString stringWithFormat:@"%@",_urlStr];
    [_shareView show:^(NSInteger PlatformTag) {
        UIImage *image = [UIImage imageNamed:@"AppLogo.png"];
        if (PlatformTag == 0) {
            [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:[NSString stringWithFormat:@"%@,%@",shareStr,_urlStr] shareImage:image title:@"银狐财富" userUrlStr:userUrlStr succeedCallback:^{
            }];
        }else{
            [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:shareStr shareImage:image title:@"银狐财富" userUrlStr:userUrlStr succeedCallback:^{
            }];
        }
    }];
}

- (void)backView
{
    if (self.webView.canGoBack)
    {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
            DLog(@"contents====%@",contents);
            NSString *contentStr = (NSString *)[contents objectAtIndex:2];
            NSString *content = [contentStr substringFromIndex:8];
            NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
            NSString *CStr=[[NSString alloc] initWithData:[GTMBase64 decodeData:data] encoding:NSUTF8StringEncoding];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)[contents objectAtIndex:1]]]];
            
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
            DLog(@"userUrlStr=====%@",userUrlStr);
            
            [_shareView show:^(NSInteger PlatformTag) {
                UIImage *image = [UIImage imageNamed:@"AppLogo.png"];
                if (PlatformTag == 0) {
                    [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:[NSString stringWithFormat:@"%@,%@",CStr,userUrlStr] shareImage:image title:title userUrlStr:userUrlStr succeedCallback:^{
                        NSString *shareSuccess = [NSString stringWithFormat:@"checkIsAppShareSuccess('share_success')"];
                        [self.webView stringByEvaluatingJavaScriptFromString:shareSuccess];
                    }];
                }else{
                    [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:CStr shareImage:image title:title userUrlStr:userUrlStr succeedCallback:^{
                        NSString *shareSuccess = [NSString stringWithFormat:@"checkIsAppShareSuccess('share_success')"];
                        [self.webView stringByEvaluatingJavaScriptFromString:shareSuccess];
                    }];
                }
            }];
        }
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appcallhtml"] == NSOrderedSame && !user)
        {
            NSString *onLoadStr2 = [NSString stringWithFormat:@"apploginsuccess('not_login')"];
            [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr2];
            [self noLogin];
        }
        
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appcallhtml"] == NSOrderedSame && user)
        {
            //js调native
            [self achiveAccountData:user];
        }
#pragma -mark 跳转到产品详情页(需参数productId)
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callappproductdetail"] == NSOrderedSame)
        {
            NSString *strArr = (NSString *)[components objectAtIndex:2];
            NSArray *contents = [strArr componentsSeparatedByString:@"&"];
            NSString *productId = (NSString *)[contents objectAtIndex:0];
            ProductDetailVC *productDetailVC = [[ProductDetailVC alloc] init];
            productDetailVC.productId = productId;
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }
#pragma -mark 跳转到产品列表页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callappproductlist"] == NSOrderedSame)
        {
            ProductVC *productVC = [[ProductVC alloc] init];
            [self.navigationController pushViewController:productVC animated:YES];
        }
#pragma -mark 跳转到银子商城列表页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppSilverStoreList"] == NSOrderedSame)
        {
            SilverTraderVC *productDetailVC = [[SilverTraderVC alloc] init];
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }
#pragma -mark 跳转到银子商城详情页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppSilverStoreDetail"] == NSOrderedSame && !user)
        {
            [self noLogin];
        }
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppSilverStoreDetail"] == NSOrderedSame && user)
        {
            
            NSString *message = (NSString *)[components objectAtIndex:2];
            NSArray *contents = [message componentsSeparatedByString:@"&"];
            DLog(@"contents====%@",contents);
            NSString *idStr = (NSString *)[contents objectAtIndex:0];
            //            NSString *nameStr = (NSString *)[contents objectAtIndex:1];
            NSString *typeStr = (NSString *)[contents objectAtIndex:2];
            NSString *silverStr = (NSString *)[contents objectAtIndex:3];
            
            SilverDetailPageVC *productDetailVC = [[SilverDetailPageVC alloc] init];
            productDetailVC.idStr = idStr;
            productDetailVC.type = typeStr;
            productDetailVC.consumeSilver = silverStr;
            
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }
#pragma -mark 跳转到我的优惠券页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppMyCouponList"] == NSOrderedSame && !user)
        {
            [self noLogin];
        }
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppMyCouponList"] == NSOrderedSame && user)
        {
            MyBonusVC *productDetailVC = [[MyBonusVC alloc] init];
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }
        
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallOnloadHtml"] == NSOrderedSame && !user)
        {
            NSString *onLoadStr2 = [NSString stringWithFormat:@"appLoginSuccess('not_login')"];
            [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr2];
            [self noLogin];
        }
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallOnloadHtml"] == NSOrderedSame && user)
        {
            // 在这里做js调native的事情
            [self achiveAccountWithData:user];
        }
        return NO;
    }
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
            _silverNB = [NSString stringWithFormat:@"%@",resultUser.silverNumber];
            _accessToken=[SCMeasureDump shareSCMeasureDump].accessTokenStr;
            NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",user.customerId,_silverNB,_accessToken,user.cellphone,user.idcard,user.name,user.accountId];
            NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
            [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            [SVProgressHUD showWithStatus:obj];
        }
    }];
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
            _accessToken=[SCMeasureDump shareSCMeasureDump].accessTokenStr;
            NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",user.customerId,_silverNB,_accessToken,user.cellphone,user.idcard,user.name,user.accountId];
            NSString *onLoadStr = [NSString stringWithFormat:@"checkFromApp('%@')",str];
            [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];
        }
        
    }];
}

- (void)onLoginOfClick:(NSNotification *)sender
{
    NSString *onLoadStr2 = [NSString stringWithFormat:@"appLoginSuccess('login_success')"];
    [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr2];
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
        [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];
    }
}


- (void)noLogin
{
    [VCAppearManager presentLoginVCWithCurrentVC:self];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //调用html页面的js方法
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
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
            _accessToken = [SCMeasureDump shareSCMeasureDump].accessTokenStr;
            NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",user.customerId,_silverNB,_accessToken,user.cellphone,user.idcard,user.name,user.accountId];
            NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
            [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];        }
    }];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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

