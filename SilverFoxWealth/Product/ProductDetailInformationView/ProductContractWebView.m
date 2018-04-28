

#import "ProductContractWebView.h"
#import "CommunalInfo.h"
#import "SCMeasureDump.h"

@interface ProductContractWebView ()<UIWebViewDelegate>

@end

@implementation ProductContractWebView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
        self.webView.delegate = self;
        self.webView.scrollView.bounces = NO;
        self.webView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.webView];
        NSString *urlStr=[NSString stringWithFormat:@"%@product/safeguard?productId=%@",LOCAL_HOST,[SCMeasureDump shareSCMeasureDump].webProductId];
        NSURL *url=[NSURL URLWithString:urlStr];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height;
    height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    if (height < [UIScreen mainScreen].bounds.size.height - 64 - 40 - 50) {
        height = [UIScreen mainScreen].bounds.size.height - 64 - 40 - 50;
    }
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, height);
    [self sendMessageToCouponsListDataRequest];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)sendMessageToCouponsListDataRequest {
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"webProductDetail" object:Nil userInfo:nil];
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

