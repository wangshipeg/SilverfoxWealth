

#import "IndianaRuleVC.h"
#import "CommunalInfo.h"

@interface IndianaRuleVC ()
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation IndianaRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    
    customNav.titleLabel.text = @"计算规则";
    self.title = @"计算规则";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.webView=[[UIWebView alloc] init];
    self.webView.scalesPageToFit=YES;
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@activities/race/rule?goodsId=%@",LOCAL_HOST,_idStr];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
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

