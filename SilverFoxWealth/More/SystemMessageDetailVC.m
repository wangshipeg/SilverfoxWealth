

#import "SystemMessageDetailVC.h"
#import "CommunalInfo.h"
#import "ShareView.h"
#import "ShareConfig.h"

@interface SystemMessageDetailVC()
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) NSString *urlStr;

@end

@implementation SystemMessageDetailVC

- (void)viewDidLoad {
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
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    weakSelf.customNav.rightButtonHandle = ^{
        [weakSelf shareTo];
    };
    self.webView=[[UIWebView alloc] init];
    self.webView.scalesPageToFit=YES;
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    if (_infoModel) {
        if ([_infoModel.type integerValue] == 1) {
            if (_infoModel.newsId.length == 0) {
                return;
            }
            _urlStr=[NSString stringWithFormat:@"%@news/detail?materialId=%@",LOCAL_HOST,_infoModel.newsId];
            NSURL *url=[NSURL URLWithString:_urlStr];
            NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
            [self.webView loadRequest:request];
        }
        if ([_infoModel.type integerValue] == 2) {
            if (_infoModel.link.length == 0) {
                return;
            }
            _urlStr=[NSString stringWithFormat:@"%@",_infoModel.link];
            NSURL *url=[NSURL URLWithString:_urlStr];
            NSURLRequest *request=[[NSURLRequest alloc] initWithURL:
                                   url];
            [self.webView loadRequest:request];
        }
        return;
    }
    NSString *urlStr=[NSString stringWithFormat:@"%@news/detail?materialId=%@",LOCAL_HOST,_newsIdStr];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}


- (void)shareTo {
    if (!_shareView) {
        _shareView=[[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:2];
    }
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    NSString *shareStr=[NSString stringWithFormat:@"%@",_infoModel.shareDesc];
    NSString *userUrlStr=[NSString stringWithFormat:@"%@",_urlStr];
    [_shareView show:^(NSInteger PlatformTag) {
        UIImage *image = [UIImage imageNamed:@"AppLogo.png"];
        
        if (PlatformTag == 0) {
            [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:[NSString stringWithFormat:@"%@,%@",shareStr,userUrlStr] shareImage:image title:@"银狐财富" userUrlStr:userUrlStr succeedCallback:^{
                NSString *shareSuccess = [NSString stringWithFormat:@"checkIsAppShareSuccess('share_success')"];
                [self.webView stringByEvaluatingJavaScriptFromString:shareSuccess];
            }];
        }else{
            [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:shareStr shareImage:image title:@"银狐财富" userUrlStr:userUrlStr succeedCallback:^{
                NSString *shareSuccess = [NSString stringWithFormat:@"checkIsAppShareSuccess('share_success')"];
                [self.webView stringByEvaluatingJavaScriptFromString:shareSuccess];
            }];
        }
    }];
}


@end

