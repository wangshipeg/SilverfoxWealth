
#import "AppDelegate.h"
#import "UserDefaultsManager.h"
#import "GesturePasswordVC.h"
#import "DataRequest.h"
#import "VCAppearManager.h"
#import "CommunalInfo.h"
#import "PictureViewController.h"
#import <AdSupport/AdSupport.h>
#import "UserInfoModel.h"
#import "RequestOAth.h"
#import "VersionNoteBaseView.h"
#import "PopupViewCell.h"
#import "UIImageView+WebCache.h"
#import "DateHelper.h"
//极光推送
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>

//UMeng分享
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "MyBonusVC.h"

//版本检测
#import "VersionInspect.h"
#import "VersionInfoModel.h"
#import "SystemMessageDetailVC.h"

//首页弹窗
#import "PopupModel.h"
#import "PopupView.h"
#import "SCMeasureDump.h"
#import "WXApi.h"

@interface AppDelegate ()<JPUSHRegisterDelegate,UITableViewDelegate,UITableViewDataSource,WXApiDelegate>
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backIndectifier;
@property (strong, nonatomic) UIView *ADView;
@property (nonatomic, strong) NSString *httpStr;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *systemSource;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSMutableArray *popupDataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *viewAlpha;
@property (nonatomic, strong) UIImageView *redBackground;
@property (nonatomic, strong) UIImageView *xiaomingImg;
@property (nonatomic, strong) NSArray *permissions;

@end

@implementation AppDelegate

+ (AppDelegate *)shareDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIViewController* myvc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = myvc;
    
    [self detectionNetworkWithRealTime];
    [self userAgentOfWebViewHttpHeader];
    [self disappearAnimation];
    [self updateUserAuthenticationInfo];
    [self configurationUmengShare];
    [self wxAuthorizationLogin];
    [self initializeSensorsAnalyticsSDK];
    [self JPush:launchOptions];
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    [self showCheckingGesturePassword];
    return YES;
}

- (void)initializeSensorsAnalyticsSDK
{
    [SensorsAnalyticsSDK sharedInstanceWithServerURL:SA_SERVER_URL andDebugMode:SensorsAnalyticsDebugOff];
    //打通与APP交互
    [[SensorsAnalyticsSDK sharedInstance] addWebViewUserAgentSensorsDataFlag];
    //渠道追踪
    [[SensorsAnalyticsSDK sharedInstance] trackInstallation:@"AppInstall"];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (user) {
        [[SensorsAnalyticsSDK sharedInstance] login:user.customerId];
    }
    //公共属性
    [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"PlatformType" : @"iOS"}];
    //自动采集
    [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart |SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppViewScreen |SensorsAnalyticsEventTypeAppClick];

    NSString *anonymousId = [[SensorsAnalyticsSDK sharedInstance] anonymousId];
    DLog(@"SensorsAnalyticsSDK 获取用户的匿名id=====%@",anonymousId);
}

- (void)userAgentOfWebViewHttpHeader {
    UIWebView *webView = [[UIWebView alloc] init];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *APPMessage = [NSString stringWithFormat:@"/silver.fox/%@/iOS/%@/%@",app_Version,[[UIDevice currentDevice] systemVersion],adId];
    NSString *httpsHeaderStr = [oldAgent stringByAppendingString:APPMessage];
    NSDictionary *dictionary = [[NSDictionary alloc]
                                initWithObjectsAndKeys:httpsHeaderStr, @"UserAgent", nil];
    DLog(@"userAgent====%@",httpsHeaderStr);
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        return;
    }
    [self handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他SDK的回调
    }
    return result;
}

- (void)JPush:(NSDictionary *)launchOptions
{
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UIUserNotificationTypeAlert |UIUserNotificationTypeBadge|UIUserNotificationTypeSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPush_ApiKey
                          channel:channel
                 apsForProduction:isProduction];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
    DLog(@"get  RegistrationID:%@",[JPUSHService registrationID]);//获取registrationID
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    DLog(@"极光推送别名======%@",user.customerId);
    if (user.customerId) {
        [JPUSHService setAlias:user.customerId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:1];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        return [self appCallbackWithopenUrl:url];
    }
    return result;
}

- (BOOL)appCallbackWithopenUrl:(NSURL *)url{
    if ([url.scheme isEqualToString:@"testWidget"]){
        NSString *productId = url.host;
        if (productId) {
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            [control setSelectedIndex:1];
            UINavigationController *VC = (UINavigationController *)control.selectedViewController;
            UIViewController *productVC = [VC topViewController];
            [VCAppearManager pushSilverWealthProductDetailWithCurrentVC:productVC model:productId];
        }else{
            UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            [control setSelectedIndex:0];
        }
    }
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
#pragma -mark 手势密码
    if (![UserDefaultsManager  gesturePasswordIsExistWith:user.customerId]) {
        return;
    }
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                    target:self
                                                  selector:@selector(timerMethod:) userInfo:nil
                                                   repeats:YES];
    self.backIndectifier = [application beginBackgroundTaskWithExpirationHandler:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (!self.myTimer.valid) {
        [self showCheckingGesturePassword];
    }
    if (self.backIndectifier != UIBackgroundTaskInvalid) {
        [self endBackgroundTask];
    }
    
    //[self JiangXiBankDepositoryNoticeView];
    [self inspectNewVersion];
    [self updateUserAuthenticationInfo];
}

- (void)updateUserAuthenticationInfo
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (user) {
        [RequestOAth authenticationUpdateWithclient_id:user.cellphone response_type:@"code" callback:^(BOOL succeedState)
         {
             if (succeedState)
             {
                 DLog(@"%@",AuthorizationSuccess);
             } else {
                 DLog(@"%@",AuthorizationFalse);
                 [UserInfoUpdate clearUserLocalInfo];
             }
         }];
    }
    [[DataRequest sharedClient] requestSendSMSMD5KEYWithCallback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                NSDictionary *dict = obj[@"data"];
                NSString *resultStr = dict[@"key"];
                [SCMeasureDump shareSCMeasureDump].signString = resultStr;
            }
        }
    }];
}

- (void) timerMethod:(NSTimer *)paramSender {
    NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining < 60) {
        [paramSender invalidate];
        [self endBackgroundTask];
    }
}

- (void) endBackgroundTask {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    __weak __typeof(self)weakSelf = self;
    dispatch_async(mainQueue, ^(void) {
        __strong __typeof(self)strongSelf = weakSelf;
        if (strongSelf != nil){
            [strongSelf.myTimer invalidate];
            [[UIApplication sharedApplication] endBackgroundTask:self.backIndectifier];
            strongSelf.backIndectifier = UIBackgroundTaskInvalid;
        }
    });
}

- (void)showCheckingGesturePassword {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
    
    if (![UserDefaultsManager  gesturePasswordIsExistWith:user.customerId]) {
        return;
    }
    //如果用户设置了手势密码 且已经登录 0.2秒后进行验证
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    GesturePasswordVC *gestureVC = [[GesturePasswordVC alloc] init];
    gestureVC.viewPersentStr = @"first";
    UIViewController *vc = [_mainTab selectedViewController];
    [vc presentViewController:gestureVC animated:YES completion:nil];
}

#pragma -mark 界面布置
- (void)decmainorateMainInterface {
    _mainTab = [[BaseTabBarController alloc] init];
    _mainTab.delegate = self;
    self.window.rootViewController = _mainTab;
    //self.window.tintColor = [UIColor iconBlueColor];
}

//实时检测网络变化
- (void)detectionNetworkWithRealTime {
    [[DataRequest sharedClient] isReachability:^(BOOL isNet) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Network_State_name object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(isNet),@"state", nil]];
        if (isNet) {
            //[self JiangXiBankDepositoryNoticeView];
            [self inspectNewVersion];
        }
    }];
}

//启动页动画
- (void)disappearAnimation {
    _ADView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
    _ADView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
    [self.window addSubview:_ADView];
    
    NSInteger intger = [UIScreen mainScreen].bounds.size.width * 2;
    if ([UIScreen mainScreen].bounds.size.width == 414) {
        intger = 1080;
    }
    [[DataRequest sharedClient]startPicturePixels:intger callback:^(id obj) {
        [self decmainorateMainInterface];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            UIImageView *imageV = [[UIImageView alloc] init];
            if (IS_iPhoneX) {
                imageV.frame = CGRectMake(0, 0,self.window.frame.size.width, self.window.frame.size.height - 120 - 34);
            } else {
                imageV.frame = CGRectMake(0, 0,self.window.frame.size.width, self.window.frame.size.height - 120);
            }
            imageV.userInteractionEnabled = YES;
            if ([obj[@"type"] intValue] != 0) {
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
                [imageV addGestureRecognizer:tapGesture];
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"跳过" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor grayColor];
            button.alpha = .7;
            button.frame = CGRectMake(self.window.frame.size.width - 80, 30, 60, 30);
            button.layer.cornerRadius = 5.0;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(removeADView) forControlEvents:UIControlEventTouchUpInside];
            [imageV addSubview:button];
            
            NSString *httpStr = obj[@"imageUrl"];
            [imageV sd_setImageWithURL:[NSURL URLWithString:httpStr] placeholderImage:nil];
            [_ADView addSubview:imageV];
        }
        [self.window bringSubviewToFront:_ADView];
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(removeADView) userInfo:nil repeats:NO];
    }];
}

-(void)removeADView
{
    [UIView animateWithDuration:1 animations:^{
        _ADView.alpha=0;
    } completion:^(BOOL finished) {
        [_ADView removeFromSuperview];
        NSNotificationCenter *messageCenter = [NSNotificationCenter  defaultCenter];
        [messageCenter postNotificationName:@"popupViewShow" object:Nil userInfo:nil];
    }];
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender
{
    [MobClick event:@"click_logo_page_img"];
    PictureViewController *rootVC = [[PictureViewController alloc] init];
    [self.window.rootViewController presentViewController:rootVC animated:NO completion:^{
    }];
}

//微信,QQ授权登录
- (void)wxAuthorizationLogin
{
    [WXApi registerApp:UM_WXAppId];
}

#pragma mark-WXAPIDelegate
- (void)onReq:(BaseReq *)req
{
    //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
}

-(void) onResp:(BaseResp*)resp
{
    //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
}

// 如果你的程序要发消息给微信，那么需要调用WXApi的sendReq函数：
-(BOOL) sendReq:(BaseReq*)req
{
    //其中req参数为SendMessageToWXReq类型。
    return YES;
}

//配置友盟分享
- (void)configurationUmengShare {
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UM_SHARE_APPKEY];
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UM_WXAppId appSecret:UM_WXAPPSecret redirectURL:UM_CallBack_Url];
    //设置分享到QQ互联的appKey和appSecret
    // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:UM_QQAppId  appSecret:nil redirectURL:UM_CallBack_Url];
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:UM_XLAPPKey  appSecret:UM_XLAppSecret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //友盟统计
    UMConfigInstance.appKey = UM_SHARE_APPKEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}

//收到推送 进入产品详情页
- (void)handleRemoteNotification:(NSDictionary *)dic {
    //打开产品详情页
    if ([dic[@"code"] integerValue] == 1) {
        NSString *productId = [NSString stringWithFormat:@"%@",dic[@"result"]];
        UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        [control setSelectedIndex:1];
        UINavigationController *VC = (UINavigationController *)control.selectedViewController;
        UIViewController *productVC = [VC topViewController];
        [VCAppearManager pushSilverWealthProductDetailWithCurrentVC:productVC model:productId];
    } else if ([dic[@"code"] integerValue] == 2) {
        //打开新闻素材
        NSString *newsId=[NSString stringWithFormat:@"%@",dic[@"result"]];
        UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        [control setSelectedIndex:2];
        
        UINavigationController *VC = (UINavigationController *)control.selectedViewController;
        SystemMessageDetailVC *sysVC = [[SystemMessageDetailVC alloc] init];
        sysVC.hidesBottomBarWhenPushed = YES;
        sysVC.newsIdStr = newsId;
        [VC pushViewController:sysVC animated:YES];
    } else if ([dic[@"code"] integerValue] == 3) {
        //打开我的优惠券
        UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        [control setSelectedIndex:3];
        UINavigationController *VC = (UINavigationController *)control.selectedViewController;
        MyBonusVC *bonusVC = [[MyBonusVC alloc] init];
        bonusVC.hidesBottomBarWhenPushed = YES;
        [VC pushViewController:bonusVC animated:YES];
    } else {
        _mainTab.selectedIndex = 0;
    }
}

#pragma mark Push Delegate
- (void)onMethod:(NSString*)method response:(NSDictionary*)data {
    //    DLog(@"method==%@",method);
    //    DLog(@"data==%@",data);
}

#pragma -mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)viewController popToRootViewControllerAnimated:YES];
    }
    [SVProgressHUD dismiss];
    switch (tabBarController.selectedIndex) {
        case 0:
            [MobClick event:@"main_tab0"];
            break;
        case 1:
            [MobClick event:@"main_tab1"];
            break;
        case 2:
            [MobClick event:@"main_tab2"];
            break;
        case 3:
            [MobClick event:@"main_tab3"];
            break;
        default:
            break;
    }
}

#pragma -mark 版本检测相关

//银行存管公告
- (void)JiangXiBankDepositoryNoticeView
{
    [[DataRequest sharedClient] JiangXiBankDepositoryNoticeWithCallback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"openNotice"] intValue] == 1) {
                UIWebView *noticeView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                noticeView.backgroundColor = [UIColor whiteColor];
                noticeView.scalesPageToFit = YES;
                noticeView.scrollView.bounces = NO;
                [[[UIApplication sharedApplication] keyWindow]addSubview:noticeView];
                NSURL *url=[NSURL URLWithString:obj[@"noticeUrl"]];
                NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
                [noticeView loadRequest:request];
                [noticeView reload];
            }
        }
    }];
}

- (void)inspectNewVersion
{
    [[DataRequest sharedClient] inspectAppVersionWithAppDeviceType:@"iosipa" Callback:^(id obj) {
        DLog(@"版本检查结果=====%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *appInfo = obj[@"appVersion"];
            NSString *appVersionStr=[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
            appVersionStr=[appVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *newVersionStr = appInfo[@"version"];
            newVersionStr=[newVersionStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            newVersionStr=[newVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            if ([appVersionStr intValue] < [newVersionStr intValue]) {
                
                NSString *upgradeType = appInfo[@"type"];
                //如果是强制更新
                if ([upgradeType caseInsensitiveCompare:@"compulsive"] == NSOrderedSame) {
                    [VersionInspect whetherUpdateWith:YES updateContent:appInfo[@"content"]];
                }else {
                    [VersionInspect whetherUpdateWith:NO updateContent:appInfo[@"content"]];
                }
            } else {
                [VersionInspect updateFinish];
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center addObserver:self selector:@selector(requestPopupData) name:@"popupViewShow" object:nil];
            }
        } else {
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center addObserver:self selector:@selector(requestPopupData) name:@"popupViewShow" object:nil];
        }
    }];
}

- (void)requestPopupData
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] recommendPopouWithUserId:user.customerId callback:^(id obj) {
        DLog(@"弹窗数据返回结果=====%@",obj);
        self.popupDataSource = [NSMutableArray array];
        self.popupDataSource = obj;
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *mutArr = [NSMutableArray array];
            for (PopupModel *model in self.popupDataSource) {
                self.idStr = model.idStr;
                [mutArr addObject:model.idStr];
            }
            if (mutArr.count > 0) {
                [self popupView:mutArr];
            }
        }
    }];
}

- (void)popupView:(NSMutableArray *)array
{
    NSUserDefaults *userDEfault = [NSUserDefaults standardUserDefaults];
    //用id作为唯一标识...
    if ([userDEfault boolForKey:self.idStr] == NO) {
        [self setupPopupView];
        [userDEfault setBool:YES forKey:self.idStr];
    }
    for (int i = 0; i < array.count; i ++) {
        if ([userDEfault boolForKey:array[i]] == NO) {
            [userDEfault setBool:YES forKey:array[i]];
        }
    }
}

- (void)setupPopupView
{
    _viewAlpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _viewAlpha.backgroundColor = [UIColor characterBlackColor];
    _viewAlpha.alpha = .5;
    [[[UIApplication sharedApplication] keyWindow]addSubview:_viewAlpha];
    _redBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup.png"]];
    _redBackground.userInteractionEnabled = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_redBackground];
    [_redBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.window.mas_left).offset(15);
        make.centerY.equalTo(self.window.mas_centerY);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width - 55));
        make.height.equalTo(@(self.popupDataSource.count * 70 + 240));
    }];
    
    UIButton *closeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBT.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"close.png"]];
    [closeBT addTarget:self action:@selector(handleCloseBT:) forControlEvents:UIControlEventTouchUpInside];
    [_redBackground addSubview:closeBT];
    [closeBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.redBackground.mas_right).offset(-10);
        make.top.equalTo(self.redBackground.mas_top).offset(30);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    _xiaomingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiaoming.png"]];
    _xiaomingImg.frame = CGRectMake(30, 0, [UIScreen mainScreen].bounds.size.width / 5, [UIScreen mainScreen].bounds.size.width / 5 * 2 - 20);
    [_redBackground addSubview:_xiaomingImg];
    [_xiaomingImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redBackground.mas_left).offset(30);
        make.top.equalTo(self.redBackground.mas_top);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width / 5));
        make.height.equalTo(@([UIScreen mainScreen].bounds.size.width / 5 * 2 - 20));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%@个优惠券已放入您的账户",[SCMeasureDump shareSCMeasureDump].totalRebate];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [_redBackground addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.redBackground.mas_centerX).offset(15);
        make.top.equalTo(self.xiaomingImg.mas_bottom);
        make.height.equalTo(@15);
    }];
    
    UILabel *pointOutLB = [[UILabel alloc] init];
    pointOutLB.text = PleaseToMyCouponListLookUp;
    pointOutLB.textColor = [UIColor whiteColor];
    pointOutLB.font = [UIFont systemFontOfSize:13];
    pointOutLB.textAlignment = NSTextAlignmentCenter;
    [_redBackground addSubview:pointOutLB];
    [pointOutLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.redBackground.mas_centerX).offset(15);
        make.bottom.equalTo(self.redBackground.mas_bottom).offset(-20);
        make.height.equalTo(@15);
    }];
    
    UIImageView *reelImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reel.png"]];
    [_redBackground addSubview:reelImg];
    [reelImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redBackground.mas_left).offset(50);
        make.top.equalTo(self.xiaomingImg.mas_bottom).offset(30);
        make.right.equalTo(self.redBackground.mas_right).offset(-25);
        make.height.equalTo(@(self.popupDataSource.count * 70 + 20));
    }];
    
    self.tableView=[[UITableView alloc] init];
    [reelImg addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reelImg.mas_left).offset(10);
        make.top.equalTo(reelImg.mas_top).offset(20);
        make.right.equalTo(reelImg.mas_right).offset(-10);
        make.height.equalTo(@(self.popupDataSource.count * 70));
    }];
}

- (void)handleCloseBT:(UIButton *)sender
{
    [_viewAlpha removeFromSuperview];
    [_redBackground removeFromSuperview];
    [_xiaomingImg removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.popupDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopupModel *model=[self.popupDataSource objectAtIndex:indexPath.section];
    static NSString *commonCell=@"popupCell";
    PopupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell];
    if (!cell) {
        cell = [[PopupViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonCell];
    }
    [cell showRebateDetailWith:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

@end






