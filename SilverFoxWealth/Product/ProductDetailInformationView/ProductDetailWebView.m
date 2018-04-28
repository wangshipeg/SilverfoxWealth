

#import "ProductDetailWebView.h"
#import "CommunalInfo.h"
#import "SCMeasureDump.h"
#import "VCAppearManager.h"
#import "AdvertisementDetailVC.h"
#import "GTMBase64.h"
#import "SVProgressHUD.h"

@interface ProductDetailWebView ()<UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic, strong) NSString *requestString;

@end

@implementation ProductDetailWebView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
        self.webView.scrollView.bounces = NO;
        self.webView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.webView];
        
        NSString *urlStr=[NSString stringWithFormat:@"%@product/mobile/detail?productId=%@",LOCAL_HOST,[SCMeasureDump shareSCMeasureDump].webProductId];
        NSURL *url=[NSURL URLWithString:urlStr];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, height);
    [self sendMessageToCouponsListDataRequest];
}

- (void)sendMessageToCouponsListDataRequest{
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"webProductDetail" object:Nil userInfo:nil];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request]) {
        return NO;
    }
    self.requestString = [[request URL] absoluteString];//获取请求的绝对路径.
    DLog(@"获取请求路径====%@",_requestString);
    NSArray *components = [_requestString componentsSeparatedByString:@"*"];//提交请求时候分割参数的分隔符
    //前提是已经登陆
    if ([components count] > 1)
    {
        //过滤请求是否是我们需要的.不需要的请求不进入条件
        if([(NSString *)[components objectAtIndex:1] caseInsensitiveCompare:@"goActiveWebview"] == NSOrderedSame)
        {
            AdvertisementDetailVC *advertisementVC=[[AdvertisementDetailVC alloc] init];
            advertisementVC.productDetailActivityTitle = @"活动详情";
            NSString *urlStr = [NSString stringWithFormat:@"http://%@",(NSString *)[components objectAtIndex:3]];
            if ([(NSString *)[components objectAtIndex:3] isEqualToString:@"www"]) {
                [SVProgressHUD showErrorWithStatus:@"请下载APP最新版本"];
                return NO;
            }
            advertisementVC.productDetailActivityUrl = urlStr;
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *VC=(UINavigationController *)control.selectedViewController;
            UIViewController *productVC=[VC topViewController];
            [productVC.navigationController pushViewController:advertisementVC animated:YES];
            
        }
        return NO;
    }
    return YES;
}

@end

