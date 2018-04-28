//
//  ShareEarnSilversVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShareEarnSilversVC.h"
#import "CommunalInfo.h"
#import "EncryptHelper.h"
#import "ShareConfig.h"
#import "DataRequest.h"
#import "WithoutAuthorization.h"
#import "UserInfoUpdate.h"
#import "VCAppearManager.h"

@interface ShareEarnSilversVC ()
@property (nonatomic, strong) NSString *shareHttp;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation ShareEarnSilversVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = _shareModel.name;
    self.title = _shareModel.name;
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
    self.webView.scalesPageToFit=YES;
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    if ([_shareModel.shareType integerValue] == 2) {
        _shareHttp = _shareModel.outLink;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:
                                 [NSURL URLWithString:_shareHttp]];
        [self.webView loadRequest:request];
        [self.webView reload];
    }
    //内部上传
    if ([_shareModel.shareType integerValue] == 1) {
        _shareHttp = [NSString stringWithFormat:@"%@news/detail?materialId=%@",LOCAL_HOST,_shareModel.shareId];
        NSURL *url=[NSURL URLWithString:_shareHttp];
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    }
}


- (void)shareTo {
    if (!_shareView) {
        _shareView=[[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:2];
    }
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [_shareView show:^(NSInteger PlatformTag) {
        UIImage *image = [UIImage imageNamed:@"AppLogo.png"];
        
        if (PlatformTag == 0) {
            [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:[NSString stringWithFormat:@"%@,%@",_shareModel.shareContent,_shareHttp] shareImage:image title:@"银狐财富" userUrlStr:_shareHttp succeedCallback:^{
                //分享成功回调
                [self shareEarnSilver:user];
            }];
        }else{
            [ShareConfig uMengContentConfigWithCellPhone:user.cellphone tag:PlatformTag presentVC:self shareContent:_shareModel.shareContent shareImage:image title:@"银狐财富" userUrlStr:_shareHttp succeedCallback:^{
                //分享成功回调
                [self shareEarnSilver:user];
            }];
        }
    }];
}

- (void)shareEarnSilver:(IndividualInfoManage *)user
{
    [[DataRequest sharedClient] silverTraderShareEarnSilvercustomerId:user.customerId callback:^(id obj) {
        DLog(@"去分享返回信息=====%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] integerValue] == 2000) {
                NSDictionary *dict = obj[@"data"];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"恭喜您" message:[NSString stringWithFormat:@"获得%@两银子",dict[@"silvers"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:otherAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        //授权
        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];//取消当前请求
            
            [UserInfoUpdate clearUserLocalInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self noLogin];
        }
        
    }];
}
- (void)noLogin
{
    [VCAppearManager presentLoginVCWithCurrentVC:self];
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

