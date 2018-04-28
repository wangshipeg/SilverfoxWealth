

#import "AdvertisementDetailVC.h"
#import "CommunalInfo.h"
#import "UMMobClick/MobClick.h"
#import "ShareConfig.h"
#import "ShareView.h"
#import <CommonCrypto/CommonDigest.h>
#import "SCMeasureDump.h"
#import "DataRequest.h"
#import "GTMBase64.h"
#import "VCAppearManager.h"
#import "PromptLanguage.h"
#import "ParseHelper.h"
#import "EncryptHelper.h"
#import "ProductVC.h"
#import "ProductDetailVC.h"
#import "ProductVC.h"
#import "SilverTraderVC.h"
#import "SilverDetailPageVC.h"
#import "MyBonusVC.h"
#import "MyAssetVC.h"
#import "UIBarButtonItem+SXCreate.h"

@interface AdvertisementDetailVC ()<UIWebViewDelegate>

@property (nonatomic, strong) ShareView *shareView;

@property (nonatomic, strong) NSString *silverNB;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *requestString;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation AdvertisementDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    [_customNav.rightButton setImage:[UIImage imageNamed:@"Share.png"] forState:UIControlStateNormal];
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    weakSelf.customNav.leftViewController = ^{
        [weakSelf backView];
    };
    weakSelf.customNav.rightButtonHandle = ^{
        [weakSelf shareTo];
    };
    
    if (_productDetailActivityTitle.length > 0) {
        _customNav.titleLabel.text = _productDetailActivityTitle;
        self.title = _productDetailActivityTitle;
    }else{
        _customNav.titleLabel.text = _advertModel.title;
        self.title = _advertModel.title;
    }
    
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    if (IS_iPhoneX) {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make)
        {
             make.top.equalTo(self.customNav.mas_bottom);
             make.left.equalTo(self.view.mas_left);
             make.right.equalTo(self.view.mas_right);
             make.bottom.equalTo(self.view.mas_bottom).offset(-34);
         }];
    } else {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.customNav.mas_bottom);
             make.left.equalTo(self.view.mas_left);
             make.right.equalTo(self.view.mas_right);
             make.bottom.equalTo(self.view.mas_bottom);
         }];
    }
    
    if ([_advertModel.type integerValue] == 1)
    {
        _urlStr=[NSString stringWithFormat:@"%@",_advertModel.outLink];
        NSURL *url=[NSURL URLWithString:_urlStr];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
        [self.webView reload];
        return;
    }
    
    if ([_advertModel.type integerValue] == 2)
    {
        _urlStr=[NSString stringWithFormat:@"%@banner/detail?bannerId=%@",LOCAL_HOST,_advertModel.idStr];
        NSURL *url=[NSURL URLWithString:_urlStr];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
        [self.webView reload];
        return;
    }
    _urlStr = [NSString stringWithFormat:@"%@",_productDetailActivityUrl];
    NSURL *url=[NSURL URLWithString:_urlStr];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (void)shareTo {
    if (!_shareView) {
        _shareView=[[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:2];
    }
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    NSString *shareStr=[NSString stringWithFormat:@"%@",_advertModel.shareContent];
    NSString *userUrlStr=[NSString stringWithFormat:@"%@",_urlStr];
    [_shareView show:^(NSInteger PlatformTag) {
        UIImage *image = [UIImage imageNamed:@"AppLogo.png"];
        if (PlatformTag == 0) {
            [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:[NSString stringWithFormat:@"%@,%@",shareStr,_urlStr] shareImage:image title:@"银狐财富" userUrlStr:userUrlStr succeedCallback:^{
            }];
        } else {
            [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:shareStr shareImage:image title:@"银狐财富" userUrlStr:userUrlStr succeedCallback:^{

            }];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        self.view = nil;
    }
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
/*
 0返回上一页, 1直接返回主界面(给跳转页面重新设定返回按钮)
 */

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
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"htmlcallappshare"] == NSOrderedSame && !user)
        {
            [self noLogin];
        }
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"htmlcallappshare"] == NSOrderedSame && user)
        {
            NSString *message = (NSString *)[components objectAtIndex:2];
            NSArray *contents = [message componentsSeparatedByString:@"&"];
            NSString *contentStr = (NSString *)[contents objectAtIndex:2];
            NSString *content = [contentStr substringFromIndex:8];
            NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
            NSString *CStr = [[NSString alloc] initWithData:[GTMBase64 decodeData:data] encoding:NSUTF8StringEncoding];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)[contents objectAtIndex:1]]]];
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
        
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallHtml"] == NSOrderedSame && !user)
        {
            [self noLogin];
        }
        
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallHtml"] == NSOrderedSame && user)
        {
            [self achiveAccountData:user];
        }
        
#pragma -mark 跳转到我的资产(需参数productId)
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppMyAssert"] == NSOrderedSame && !user)
        {
            NSString *isClose = (NSString *)[components objectAtIndex:2];
            if ([isClose intValue] == 1) {
                [self noDataLogin];
            } else {
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
            productDetailVC.whereFrom = @"banner";
            if ([isClose intValue] == 1) {
                [self pushToRootVC:productDetailVC];
            }
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }
#pragma -mark 跳转到银子商城详情页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppSilverStoreDetail"] == NSOrderedSame && !user)
        {
            NSString *isClose = (NSString *)[components objectAtIndex:2];
            if ([isClose intValue] == 1) {
                [self noDataLogin];
            }else{
                [self noLogin];
            }
        }
        
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppSilverStoreDetail"] == NSOrderedSame && user)
        {
            NSString *message = (NSString *)[components objectAtIndex:2];
            NSArray *contents = [message componentsSeparatedByString:@"&"];
            NSString *idStr = (NSString *)[contents objectAtIndex:0];
            NSString *nameStr = (NSString *)[contents objectAtIndex:1];
            NSData *data = [nameStr dataUsingEncoding:NSUTF8StringEncoding];
            NSString *CStr = [[NSString alloc] initWithData:[GTMBase64 decodeData:data] encoding:NSUTF8StringEncoding];
            
            NSString *typeStr = (NSString *)[contents objectAtIndex:2];
            NSString *silverStr = (NSString *)[contents objectAtIndex:3];
            NSString *isClose = (NSString *)[contents objectAtIndex:4];
            SilverDetailPageVC *productDetailVC = [[SilverDetailPageVC alloc] init];
            productDetailVC.idStr = idStr;
            productDetailVC.type = typeStr;
            productDetailVC.consumeSilver = silverStr;
            productDetailVC.nameStr = CStr;
            if ([isClose intValue] == 1) {
                [self pushToRootVC:productDetailVC];
            }
            [self.navigationController pushViewController:productDetailVC animated:YES];
        }
#pragma -mark 跳转到我的优惠券页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppMyCouponList"] == NSOrderedSame && !user)
        {
            NSString *isClose = (NSString *)[components objectAtIndex:2];
            if ([isClose intValue] == 1) {
                [self noDataLogin];
            }else{
                [self noLogin];
            }
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
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallOnloadHtml"] == NSOrderedSame && user)
        {
            // 在这里做js调native的事情
            [self achiveAccountWithData:user];
        }
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
            _silverNB = [NSString stringWithFormat:@"%@",resultUser.silverNumber];
            _accessToken=[SCMeasureDump shareSCMeasureDump].accessTokenStr;
            NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",user.customerId,_silverNB,_accessToken,user.cellphone,user.idcard,user.name,user.accountId];
            NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
            [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];
        }
    }];
}

- (void)achiveAccountData:(IndividualInfoManage *)user
{
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
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

- (void)pushToRootVC:(UIViewController*)vc
{
    //    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToRootVC:) image:[UIImage imageNamed:@"nav_back.png"]];
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
        _accessToken = [SCMeasureDump shareSCMeasureDump].accessTokenStr;
        NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"silverfox_app",[SCMeasureDump shareSCMeasureDump].userOfObj.customerId,_silverNB,_accessToken,[SCMeasureDump shareSCMeasureDump].userOfObj.cellphone,[SCMeasureDump shareSCMeasureDump].userOfObj.idcard,[SCMeasureDump shareSCMeasureDump].userOfObj.name,[SCMeasureDump shareSCMeasureDump].userOfObj.accountId];                    NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
        [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];
    }
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)noLogin
{
    [VCAppearManager presentLoginVCWithCurrentVC:self];
}

- (void)noDataLogin
{
    //如果是跳转到原生界面的未登陆,这样模态出登陆视图
    [self.navigationController popToRootViewControllerAnimated:YES];
    [VCAppearManager presentLoginVCWithCurrentVC:self];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    //调用html页面的js方法
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
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
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
-(void)dealloc
{
    _webView.delegate = nil;
    [_webView stopLoading];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

