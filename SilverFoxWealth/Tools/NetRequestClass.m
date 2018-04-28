

#import "NetRequestClass.h"
#import"AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "CommunalInfo.h"
#import <AdSupport/AdSupport.h>
#import "UserDefaultsManager.h"

@interface NetRequestClass ()

@end

@implementation NetRequestClass
//与银狐对接
+(instancetype)sharedClient{
    static NetRequestClass *sheredClient=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sheredClient=[[NetRequestClass alloc] initWithBaseURL:[NSURL URLWithString:SILVERFOX_BASE_URL]];
        sheredClient.session.configuration.timeoutIntervalForRequest=10; //超时时间
        sheredClient.securityPolicy = [self customSecurityPolicy];
        sheredClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return sheredClient;
}

+ (AFSecurityPolicy *)customSecurityPolicy {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    return securityPolicy;
}

//消息中心 即时查询数据
+(instancetype)sharedMessageCenter{
    static NetRequestClass *messageCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageCenter = [[NetRequestClass alloc] initWithBaseURL:[NSURL URLWithString:SILVERFOX_BASE_URL]];
        messageCenter.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return messageCenter;
}

//银狐内调
- (void)operateSilverFoxDataWith:(NSString *)method
                             url:(NSString *)url
                          params:(NSDictionary *)params
            WithReturnValeuBlock:(ReturnValueBlock) block
              WithErrorCodeBlock:(ErrorCodeBlock) errorBlock
                WithFailureBlock:(FailureBlock) failureBlock
{
    //如果当前有请求的任务
    if (self.dataTasks.count != 0) {
        //获取到当前正在请求的任务
        for (NSURLSessionDataTask *task in self.dataTasks) {
            //当前正在请求的url地址
            NSURL *cuUrl = task.currentRequest.URL;
            NSString *currentUrl = [NSString stringWithFormat:@"%@",cuUrl];
            //本次请求的url地址
            NSString *thisTimeUrl = [NSString stringWithFormat:@"%@%@",SILVERFOX_BASE_URL,url];
            //如果本次请求和当前请求是同一个url地址  那么 取消上次的请求 继续本次的请求
            if ([currentUrl isEqualToString:thisTimeUrl]) {
                [task cancel];
            }
        }
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //app信息
    NSString *APPMessage = [NSString stringWithFormat:@"silver.fox/%@/IOS/%.1f/%@",app_Version,[[[UIDevice currentDevice] systemVersion] floatValue],idfa];
    [self.requestSerializer setValue:[UserDefaultsManager searchUserApiKey] forHTTPHeaderField:@"Authorization"];
    [self.requestSerializer setValue:[NSString stringWithString:APPMessage] forHTTPHeaderField:@"User-Agent"];

    NSURLSessionDataTask *task = nil;
    
    if ([method isEqualToString:@"GET"]) {
        
        task = [self GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            /******************************
             在这做判断如果有dic里有errorCode
             调用errorBlock(dic)
             没有errorCode则调用block(dic
             ******************************/
            block(dic);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
        }];
    }
    
    if ([method isEqualToString:@"POST"]) {
        task = [self POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            block(dic);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
        }];
    }
}

#pragma -mark 网络状态监测
//检查网络可达性 包括实时检测
- (void)isReachability:(void(^)(BOOL isNet))netBlock urlStr:(NSString *)urlStr{
    NSURL *baseURL = [NSURL URLWithString:urlStr];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netBlock(YES);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [operationQueue setSuspended:NO];
                netBlock(YES);
                break;
            case AFNetworkReachabilityStatusUnknown:
                netBlock(NO);
                break;
            default:
                [operationQueue setSuspended:YES];
                netBlock(NO);
                break;
        }
    }];
    [self.reachabilityManager startMonitoring];
}

@end



