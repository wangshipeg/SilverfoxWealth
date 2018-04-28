
#import "ProductIntroduceWebView.h"
#import "CommunalInfo.h"
#import "SCMeasureDump.h"

@interface ProductIntroduceWebView ()<UIWebViewDelegate>

@end

@implementation ProductIntroduceWebView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
        self.webView.opaque = NO;
        self.webView.scrollView.bounces = NO;
        self.webView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.webView];
        NSString *urlStr = [NSString stringWithFormat:@"%@product/risk/controlment?productId=%@",LOCAL_HOST,[SCMeasureDump shareSCMeasureDump].webProductId];
        NSURL *url=[NSURL URLWithString:urlStr];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
        self.webView.frame = CGRectMake(0, 0, fittingSize.width, fittingSize.height);
        [self sendMessageToCouponsListDataRequest];
    }
}

- (void)sendMessageToCouponsListDataRequest{
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"webProductDetail" object:Nil userInfo:nil];
}


@end

