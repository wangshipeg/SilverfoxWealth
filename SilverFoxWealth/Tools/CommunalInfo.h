

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef kReleaseH
#define SILVERFOX_BASE_URL       @"https://api.yinhujinfu.cn/"
#define LOCAL_HOST               @"https://www.yinhujinfu.cn/"
#define JPush_ApiKey             @"a344214f8952dbf09c1b3734"
// 数据接收的 URL
#define SA_SERVER_URL            @"http://47.96.189.109:8106/sa?project=production"

#elif  kPreTest
#define SILVERFOX_BASE_URL       @"http://192.168.1.112:9000/"
#define LOCAL_HOST               @"http://192.168.1.112:9017/"
#define JPush_ApiKey             @"28c3c01f90be77d552637443"
#define SA_SERVER_URL            @"http://47.96.189.109:8106/sa?project=default"

#elif  kSitTest
#define SILVERFOX_BASE_URL       @"http://192.168.1.111:9000/"
#define LOCAL_HOST               @"http://192.168.1.111:9017/"
#define JPush_ApiKey             @"28c3c01f90be77d552637443"
#define SA_SERVER_URL            @"http://47.96.189.109:8106/sa?project=default"

#elif  kLocalTest
#define SILVERFOX_BASE_URL       @"http://192.168.1.111:9000/"
#define LOCAL_HOST               @"http://192.168.1.173:9018/"
#define JPush_ApiKey             @"28c3c01f90be77d552637443"
#define SA_SERVER_URL            @"http://47.96.189.109:8106/sa?project=default"

#endif

//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)();
typedef void (^NetWorkBlock)(BOOL netConnetState);

//用户本地存储标识
UIKIT_EXTERN NSString *const UserDefaultManagerForSignDate;
UIKIT_EXTERN NSString *const UserBankCardNumCacheForString;
UIKIT_EXTERN NSString *const UserRequestApiKey;
UIKIT_EXTERN NSString *const UserGesturePasswordService;
UIKIT_EXTERN NSString *const UserExpriresIn;
UIKIT_EXTERN NSString *const UserRefreshToken;

#define BankInterestRate         0.0035                 //银行利率
#define Wait_Time                1.0                    //修改成功后的等待时间 单位为秒
#define Message_Center_Name      @"New_Message"         //消息中心之 用户消息 发送 接收 名字
#define Network_State_name       @"CurrentNetworkState" //消息中心之  当前网络状态 发送接收 名字

//友盟
#define UM_SHARE_APPKEY          @"5502ad25fd98c5f05e000a22"

//微信
#define UM_WXAppId               @"wxae45092458d51241"
#define UM_WXAPPSecret           @"f8f233b6aadfb78ff8c041af1d5c75a7"
#define UM_CallBack_Url          @"http://www.umeng.com/social"

//QQ
#define UM_QQAppId               @"1104648245"
#define UM_QQAPPKey              @"ViZtGeO6t9t6kuly"
#define UM_QQUrl                 @"http://www.umeng.com/social"

//新浪
#define UM_XLAPPKey              @"1425234072"
#define UM_XLAppSecret           @"13adf30144e6a3b9e2e7b02ffd6add4f"

#define UDeskAPPId               @"5bd4018ff8159929"
#define UDeskAPPKey              @"42043b6ab765904b908ad94822f822dd"
#define UDeskAccount             @"silverfox-cn.udesk.cn"

@interface CommunalInfo : NSObject

@end
