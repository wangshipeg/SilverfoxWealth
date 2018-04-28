

#import "PictureViewController.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
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

@interface PictureViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *httpStr;

@property (nonatomic, strong) NSString *silverNB;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *requestString;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) ShareView *shareView;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataRequest sharedClient]startPicturePixels:[UIScreen mainScreen].bounds.size.width * 2 callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if (IS_iPhoneX) {
                _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
            }else{
                _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
            }
            _customNav.titleLabel.text = @"详情";
            [self.view addSubview:_customNav];
            __weak typeof (self) weakSelf = self;
            weakSelf.customNav.leftViewController = ^{
                [weakSelf handleClickRightItem];
            };
            if ([obj[@"type"] intValue] == 2) {
                _httpStr = [NSString stringWithFormat:@"%@banner/detail?bannerId=%@",LOCAL_HOST,obj[@"id"]];
            } else {
                _httpStr = obj[@"outLink"];
            }
            if (_httpStr) {
                NSURL *url = [NSURL URLWithString:_httpStr];
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
                self.webView=[[UIWebView alloc] init];
                self.webView.scalesPageToFit=YES;
                self.webView.delegate = self;
                self.webView.scrollView.bounces = NO;
                [_webView loadRequest:requestUrl];
                [self.view addSubview:_webView];
                [_webView mas_makeConstraints:^(MASConstraintMaker *make)
                 {
                     make.top.equalTo(self.customNav.mas_bottom);
                     make.left.equalTo(self.view.mas_left);
                     make.right.equalTo(self.view.mas_right);
                     make.bottom.equalTo(self.view.mas_bottom);
                 }];
            }
        }
    }];
}

- (void)handleClickRightItem{
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self dismissViewControllerAnimated: YES completion: nil];
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
            //分享内容
            NSString *contentStr = (NSString *)[contents objectAtIndex:2];
            NSString *content = [contentStr substringFromIndex:8];
            NSData *data=[content dataUsingEncoding:NSUTF8StringEncoding];
            NSString *CStr=[[NSString alloc] initWithData:[GTMBase64 decodeData:data] encoding:NSUTF8StringEncoding];
            //分享图片
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)[contents objectAtIndex:1]]]];
            //分享标题
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
        
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallHtml"] == NSOrderedSame && !user)
        {
            [self noLogin];
        }
        
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallHtml"] == NSOrderedSame && user)
        {
            // 在这里做js调native的事情
            // 做完之后用如下方法调回js
            [UserInfoUpdate updateUserInfoWithTargerVC:self];
            IndividualInfoManage *resultUser = [IndividualInfoManage currentAccount];
            _silverNB = [NSString stringWithFormat:@"%@",resultUser.silverNumber];
            _accessToken=[SCMeasureDump shareSCMeasureDump].accessTokenStr;
            NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"jzjf_app",user.customerId,_silverNB,_accessToken,user.cellphone,user.idcard,user.name,user.accountId];
            NSString *onLoadStr = [NSString stringWithFormat:@"checkFromApp('%@')",str];
            [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];
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
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *VC = (UINavigationController *)control.selectedViewController;
            [control setSelectedIndex:1];
            UIViewController *rootVC = [VC topViewController];
            //显示导航栏
            VC.navigationController.navigationBarHidden = NO;
            [self dismissViewControllerAnimated:YES completion: nil];
            [rootVC.navigationController pushViewController:productDetailVC animated:YES];
        }
        
        
#pragma -mark 跳转到产品列表页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppProductList"] == NSOrderedSame)
        {
            NSString *isClose = (NSString *)[components objectAtIndex:2];
            ProductVC *productVC = [[ProductVC alloc] init];
            if ([isClose intValue] == 1) {
                [self pushToRootVC:productVC];
            }
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *VC = (UINavigationController *)control.selectedViewController;
            [control setSelectedIndex:1];
            UIViewController *rootVC = [VC topViewController];
            //显示导航栏
            VC.navigationController.navigationBarHidden = NO;
            [self dismissViewControllerAnimated:YES completion: nil];
            [rootVC.navigationController pushViewController:productVC animated:YES];
        }
#pragma -mark 跳转到银子商城列表页
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"callAppSilverStoreList"] == NSOrderedSame)
        {
            NSString *isClose = (NSString *)[components objectAtIndex:2];
            SilverTraderVC *productDetailVC = [[SilverTraderVC alloc] init];
            if ([isClose intValue] == 1) {
                [self pushToRootVC:productDetailVC];
            }
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *VC = (UINavigationController *)control.selectedViewController;
            [control setSelectedIndex:1];
            UIViewController *rootVC = [VC topViewController];
            //显示导航栏
            VC.navigationController.navigationBarHidden = NO;
            [self dismissViewControllerAnimated:YES completion: nil];
            [rootVC.navigationController pushViewController:productDetailVC animated:YES];
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
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *VC = (UINavigationController *)control.selectedViewController;
            [control setSelectedIndex:1];
            UIViewController *rootVC = [VC topViewController];
            //显示导航栏
            VC.navigationController.navigationBarHidden = NO;
            [self dismissViewControllerAnimated:YES completion: nil];
            [rootVC.navigationController pushViewController:productDetailVC animated:YES];
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
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *VC = (UINavigationController *)control.selectedViewController;
            [control setSelectedIndex:1];
            UIViewController *rootVC = [VC topViewController];
            //显示导航栏
            VC.navigationController.navigationBarHidden = NO;
            [self dismissViewControllerAnimated:YES completion: nil];
            [rootVC.navigationController pushViewController:myBonusVC animated:YES];
        }
        
        if ([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"appCallOnloadHtml"] == NSOrderedSame && user)
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
                    _accessToken = [SCMeasureDump shareSCMeasureDump].accessTokenStr;
                    NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"jzjf_app",user.customerId,_silverNB,_accessToken,user.cellphone,user.idcard,user.name,user.accountId];
                    NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
                    [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];
                }
            }];
        }
        return NO;
    }
    return YES; //继续对本次请求进行导航
}

- (void)pushToRootVC:(UIViewController*)vc
{
    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToRootVC:) image:[UIImage imageNamed:@"nav_back.png"]];
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
        NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"jzjf_app",[SCMeasureDump shareSCMeasureDump].userOfObj.customerId,_silverNB,_accessToken,[SCMeasureDump shareSCMeasureDump].userOfObj.cellphone,[SCMeasureDump shareSCMeasureDump].userOfObj.idcard,[SCMeasureDump shareSCMeasureDump].userOfObj.name,[SCMeasureDump shareSCMeasureDump].userOfObj.accountId];
        NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
        [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];    }
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)noLogin
{
    //如果未登陆,模态出登陆视图
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
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
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
            NSString* str = [NSString stringWithFormat:@"{\"isApp\":\"%@\",\"customerId\":\"%@\",\"silver_num\":\"%@\",\"accessToken\":\"%@\",\"cellphone\":\"%@\",\"idcard\":\"%@\",\"name\":\"%@\",\"accountId\":\"%@\"}",@"jzjf_app",user.customerId,_silverNB,_accessToken,user.cellphone,user.idcard,user.name,user.accountId];
            NSString *onLoadStr = [NSString stringWithFormat:@"onLoadCheckFromApp('%@')",str];
            [self.webView stringByEvaluatingJavaScriptFromString:onLoadStr];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

