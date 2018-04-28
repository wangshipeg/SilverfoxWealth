//
//  FinanclalColumnWebViewVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FinanclalColumnWebViewVC.h"
#import "CommunalInfo.h"
#import "ShareView.h"
#import "ShareConfig.h"

@interface FinanclalColumnWebViewVC ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation FinanclalColumnWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    weakSelf.customNav.rightButtonHandle = ^{
        [weakSelf shareTo];
    };
    self.webView=[[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    //self.webView.delegate = self;
    [self.view addSubview:self.webView];
    if (IS_iPhoneX) {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.customNav.mas_bottom);
             make.left.equalTo(self.view.mas_left);
             make.right.equalTo(self.view.mas_right);
             make.bottom.equalTo(self.view.mas_bottom).offset(-34);
         }];
    }else{
        [_webView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.customNav.mas_bottom);
             make.left.equalTo(self.view.mas_left);
             make.right.equalTo(self.view.mas_right);
             make.bottom.equalTo(self.view.mas_bottom);
         }];
    }
    
    if ([_model.type integerValue] == 0)
    {
        _urlStr=[NSString stringWithFormat:@"%@",self.model.outLink];
        NSURL *url=[NSURL URLWithString:_urlStr];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
        [self.webView reload];
    }
    if ([self.model.type integerValue] == 1)
    {
        _urlStr=[NSString stringWithFormat:@"%@news/detail?materialId=%@",LOCAL_HOST,self.model.idStr];
        NSURL *url=[NSURL URLWithString:_urlStr];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    }
    [[SensorsAnalyticsSDK sharedInstance] track:@"DetailsView"
                                 withProperties:@{
                                                  @"NewsTitle" : _model.title,
                                                  }];
    // Do any additional setup after loading the view.
}

- (void)shareTo {
    if (!_shareView) {
        _shareView=[[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:2];
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

