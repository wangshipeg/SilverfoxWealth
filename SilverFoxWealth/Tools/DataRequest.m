
#import "DataRequest.h"
#import "UserDefaultsManager.h"
#import "CommunalInfo.h"
#import "ParseHelper.h"
#import "VersionInfoModel.h"
#import "IndividualInfo.h"
#import <AdSupport/AdSupport.h>

@implementation DataRequest

//与银狐对接
+(instancetype)sharedClient{
    static DataRequest *sheredClient=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sheredClient=[[DataRequest alloc] initWithBaseURL:[NSURL URLWithString:SILVERFOX_BASE_URL]];
        sheredClient.session.configuration.timeoutIntervalForRequest = 10; //超时时间
        sheredClient.securityPolicy=[self customSecurityPolicy];
        sheredClient.responseSerializer=[AFHTTPResponseSerializer serializer];
    });
    return sheredClient;
}


+ (AFSecurityPolicy *)customSecurityPolicy {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates=YES;
    [securityPolicy setValidatesDomainName:NO];
    return securityPolicy;
}

//消息中心 即时查询数据
+(instancetype)sharedMessageCenter{
    static DataRequest *messageCenter=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageCenter=[[DataRequest alloc] initWithBaseURL:[NSURL URLWithString:SILVERFOX_BASE_URL]];
        messageCenter.responseSerializer=[AFHTTPResponseSerializer serializer];
    });
    return messageCenter;
}

//银狐内调
-(NSURLSessionDataTask *)operateSilverFoxDataWith:(NSString *)method
                                              url:(NSString *)url
                                           params:(NSDictionary *)params
                                         callback:(void(^)(id obj))callback {
    if (self.dataTasks.count != 0) {
        for (NSURLSessionDataTask *task in self.dataTasks) {
            NSURL *cuUrl=task.currentRequest.URL;
            NSString *currentUrl=[NSString stringWithFormat:@"%@",cuUrl];
            NSString *thisTimeUrl=[NSString stringWithFormat:@"%@%@",SILVERFOX_BASE_URL,url];
            if ([currentUrl isEqualToString:thisTimeUrl]) {
                [task cancel];
            }
        }
    }
    
    if ([UserDefaultsManager searchUserApiKey]) {
        [self.requestSerializer setValue:[UserDefaultsManager searchUserApiKey] forHTTPHeaderField:@"Authorization"];
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *APPMessage = [NSString stringWithFormat:@"silver.fox/%@/IOS/%@/%@",app_Version,[[UIDevice currentDevice] systemVersion],idfa];
    [self.requestSerializer setValue:[NSString stringWithString:APPMessage] forHTTPHeaderField:@"User-Agent"];

    NSURLSessionDataTask *task = nil;
    
    if ([method isEqualToString:@"GET"]) {
        
        task = [self GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callback(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(error);
        }];
    }
    
    if ([method isEqualToString:@"POST"]) {
        task = [self POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callback(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(error);
        }];
    }
    
    if ([method isEqualToString:@"PUT"]) {
        task = [self PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callback(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(error);
        }];
    }
    return task;
}

#pragma -mark 网络状态监测
- (void)isReachability:(void(^)(BOOL isNet))netBlock {
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                netBlock(YES);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                netBlock(YES);
                break;
            case AFNetworkReachabilityStatusUnknown:
                netBlock(NO);
                break;
            default:
                netBlock(NO);
                break;
        }
    }];
    [self.reachabilityManager startMonitoring];
}

/**
 *找回密码之 根据手机号确定用户是否为投资客
 */
- (void)provingCustomerStatusAndAchieveCheckingCodeWithCellphone:(NSString *)cellphone
                                               callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cellphone"] = cellphone;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"customers/validation"
                            params:param callback:^(id obj) {
                                if ([obj isKindOfClass:[NSError class]]) {
                                    callback([ParseHelper parseToError:obj]);
                                    return;
                                }
                                //如果正常 把数据传回去
                                callback([ParseHelper parseToCode:obj]);
                            }];
}

//使用手机号、验证码、密码、设备id 进行注册
- (void)registWithPhoneNum:(NSString *)cellphone
                      code:(NSString *)code
                  password:(NSString *)password
                  deviceId:(NSString *)deviceId
                 channelId:(NSString *)channelId
       invitationCellphone:(NSString *)invitationCellphone
                  callback:(void(^)(id obj))callback{
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"cellphone"]=cellphone;
    param[@"code"]=code;
    param[@"password"]=password;
    param[@"deviceId"]=deviceId;
    param[@"channelId"]=channelId;
    param[@"invitationCellphone"] = invitationCellphone;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"customers/reg"
                            params:param
                          callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

//使用手机号、密码登录
- (void)loginWithCellphone:(NSString *)cellphone
                password:(NSString *)password
               callback:(void(^)(id obj))callback {
    NSDictionary *param=NSDictionaryOfVariableBindings(cellphone,password);
    [self operateSilverFoxDataWith:@"POST" url:@"customers/login"
                            params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCustomer:obj]);
    }];
}

//找回登录密码 之 发送短信
- (void)retrieveLoginPasswordForSendNoteWithCellphone:(NSString *)cellphone
                                             idcard:(NSString *)idcard
                                                 sign:(NSString *)sign
                                           callback:(void(^)(id obj))callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cellphone"] = cellphone;
    param[@"sign"] = sign;
    param[@"idcard"] = idcard;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"customers/retrieve/password/validate"
                            params:param
                          callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToIdCardDic:obj]);
    }];
    
}

//找回登录密码 之 提交新密码
- (void)retrieveLoginPasswordForSubmitNewPasswordWithPhoneNum:(NSString *)cellphone
                                                        code:(NSString *)code
                                                    password:(NSString *)password
                                                    callback:(void(^)(id obj))callback {

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cellphone"] = cellphone;
    param[@"code"] = code;
    param[@"password"] = password;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"customers/reset/password"
                            params:param
                          callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
    
}

//重新获取验证码 包括 注册 和 登录
- (void)afreshAchieveVerificationCodeWithCellphone:(NSString *)cellphone smsType:(NSString *)smsType sign:(NSString *)sign callback:(void(^)(id obj))callback {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cellphone"] = cellphone;
    param[@"smsType"] = smsType;
    param[@"sign"] = sign;
    [self operateSilverFoxDataWith:@"POST" url:@"extras/sms/code" params:param callback:^(id obj) {
        
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

#pragma -mark 交易密码相关接口

//设置交易密码
- (void)installTradePasswordWithcustomerId:(NSString *)customerId
                         tradePassword:(NSString *)tradePassword
                              callback:(void(^)(id obj))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    param[@"tradePassword"] = tradePassword;
    
    [self operateSilverFoxDataWith:@"POST"
                               url:@"user/trade/password"
                            params:param callback:^(id obj) {
        
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToSetTradePassword:obj]);
        
    }];
    
}

/**
 *更换手机号 之  验证手机号(两种情况的第一步)
 */

- (void)exchangePhoneNumberForCensorCodeWithCellphone:(NSString *)cellphone
                                               idCard:(NSString *)idCard
                                              smsCode:(NSString *)smsCode
                                              smsType:(NSString *)smsType
                                             callback:(void(^)(id obj))callback{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"cellphone"] = cellphone;
    param[@"smsCode"] = smsCode;
    param[@"smsType"] = smsType;
    param[@"idCard"] = idCard;
    [self operateSilverFoxDataWith:@"POST" url:@"customers/change/cellphone/validate" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

/**
 *更换手机号 之  验证新手机号
 */
- (void)exchangeNewPhoneNumberForCensorCodeWithCellphone:(NSString *)cellphone
                                                 smsCode:(NSString *)smsCode
                                                authCode:(NSString *)authCode
                                                 channel:(NSString *)channel
                                               accountId:(NSString *)accountId
                                                callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"cellphone"] = cellphone;
    param[@"smsCode"] = smsCode;
    param[@"authCode"] = authCode;
    param[@"channel"] = channel;
    param[@"accountId"] = accountId;

    [self operateSilverFoxDataWith:@"POST" url:@"customers/change/cellphone" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

//获取投资客信息  ???
- (void)achieveCustomerUserInfoWithcustomerId:(NSString *)customerId
                                     callback:(void(^)(id obj))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"customers/info"
                            params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCustomer:obj]);
    }];
}

- (void)AchieveCustomerUserInfoFundTradeAmountWithcustomerId:(NSString *)customerId
                                                 callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"customers/common/trade/amount"
                            params:param callback:^(id obj) {
                                if ([obj isKindOfClass:[NSError class]]) {
                                    callback([ParseHelper parseToError:obj]);
                                    return;
                                }
                                callback([ParseHelper parseToDic:obj]);
                            }];
}

/**
 *当前手机号审核状态
 */
- (void)startsWithCustomerId:(NSString *)customerId callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;

    NSString *url = [NSString stringWithFormat:@"customers/cellphone/state"];
    [self operateSilverFoxDataWith:@"GET"
                               url:url
                            params:param callback:^(id obj) {
                                
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
            }
        callback([ParseHelper parseToDic:obj]);
    }];
}

#pragma -mark 精品推荐
//精品推荐banner数据
- (void)perfectRecommendationWithCallback:(void(^)(id obj))callback {
    [self operateSilverFoxDataWith:@"GET"
                               url:@"extras/recommendation"
                            params:nil callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToRecommend:obj]);
    }];
}
//
- (void)perfectRecommendationProductCallback:(void(^)(id obj))callback
{
    [self operateSilverFoxDataWith:@"GET"
                               url:@"products/recommendation"
                            params:nil callback:^(id obj) {
                                if ([obj isKindOfClass:[NSError class]]) {
                                    callback([ParseHelper parseToError:obj]);
                                    return;
                                }
                                callback([ParseHelper parseToRecommendProduct:obj]);
                            }];
}

- (void)recommendPopouWithUserId:(NSString *)userId
                            callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = userId;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"assets/system/coupons"
                            params:param
                          callback:^(id obj) {
                                if ([obj isKindOfClass:[NSError class]]) {
                                    callback([ParseHelper parseToError:obj]);
                                    return;
                                }
                                callback([ParseHelper parseToRecommendPopup:obj]);
                            }];
}

/**
 *本月累计签到天数领取奖励列表
 */
- (void)recommendationSignInRewardWithCallback:(void(^)(id obj))callback
{
    NSString *url=[NSString stringWithFormat:@"activities/sign/prizes"];
    
    [self operateSilverFoxDataWith:@"GET"
                               url:url
                            params:nil
                          callback:^(id obj) {
                              
                              if ([obj isKindOfClass:[NSError class]]) {
                                  callback([ParseHelper parseToError:obj]);
                                  return;
                              }
                              callback([ParseHelper monthSignInPrizeListList:obj]);
                          }];
}

/**
 *领取签到奖品记录
 */
- (void)recommendationSignInRecordWithcustomerId:(NSString *)customerId callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"activities/achieve/prizes/records"
                            params:param
                          callback:^(id obj) {
                              if ([obj isKindOfClass:[NSError class]]) {
                                  callback([ParseHelper parseToError:obj]);
                                  return;
                              }
                              callback([ParseHelper monthSignInGetRecordList:obj]);
                          }];
}

/**
 *领取签到奖品列表
 */
- (void)recommendationSignInPrizeWithcustomerId:(NSString *)customerId
                                        prizeId:(NSString *)prizeId
                                    callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    param[@"prizeId"] = prizeId;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"activities/achieve/sign/prizes"
                            params:param
                          callback:^(id obj) {
                              if ([obj isKindOfClass:[NSError class]]) {
                                  callback([ParseHelper parseToError:obj]);
                                  return;
                              }
                              callback([ParseHelper monthSignInRewardList:obj]);
                          }];
}

/**
 *本月累计签到天数
 */
- (void)recommendationSignInTimesWithcustomerId:(NSString *)customerId callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"activities/sign/records"
                            params:param
                          callback:^(id obj) {
                              
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper monthSignInTimesList:obj]);
    }];
}
- (void)recommendFillSignWithCustomerId:(NSString *)customerId
                                   date:(NSString *)date
                               callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    param[@"date"] = date;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"activities/fill/sign"
                            params:param
                          callback:^(id obj) {
                              
                              if ([obj isKindOfClass:[NSError class]]) {
                                  callback([ParseHelper parseToError:obj]);
                                  return;
                              }
                              callback([ParseHelper parseToDic:obj]);
                          }];
}
- (void)recommendFillSignPageNumberWithCustomerId:(NSString *)customerId
                                         callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"activities/retroactive/num"
                            params:param
                          callback:^(id obj) {
                              if ([obj isKindOfClass:[NSError class]]) {
                                  callback([ParseHelper parseToError:obj]);
                                  return;
                              }
                              callback([ParseHelper parseToDic:obj]);
                          }];
}
#pragma -mark 理财产品
//获取银狐财富列表数据
- (void)achieveSilverWealthWithPage:(int)page
                         categoryId:(NSString *)categoryId
                             status:(NSString *)status
                             period:(NSString *)period
                           callback:(void(^)(id obj))callback {
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"categoryId"] = categoryId;
    param[@"status"] = status;
    param[@"period"] = period;
    param[@"page"] = [NSString stringWithFormat:@"%d",page];
    [self operateSilverFoxDataWith:@"GET"
                               url:[NSString stringWithFormat:@"products/"]
                            params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToSilverWealthList:obj]);
    }];
}
/**
 *跑马灯
 */
- (void)leightSilverWealthWithListCallback:(void(^)(id obj))callback
{
    [self operateSilverFoxDataWith:@"GET" url:@"extras/product/notices" params:nil callback:^(id obj) {
            if ([obj isKindOfClass:[NSError class]]) {
                callback([ParseHelper parseToError:obj]);
                    return;
            }
        callback([ParseHelper parseToCode:obj]);
    }];
}

- (void)leightForSilverGoodsWithCustomerId:(NSString *)customerId callback:(void(^)(id obj))callback
{
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"GET" url:@"activities/silvers/store/main" params:params callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

/**
 *获取详情页 购买记录
 */
- (void)achieveProductDetailBuyBlockUpWith:(int)page
                                 productId:(NSString *)productId
                                  callback:(void(^)(id obj))callback
{
    NSString *urlStr=[NSString stringWithFormat:@"products/orders"];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"productId"]=productId;
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    [self operateSilverFoxDataWith:@"GET" url:urlStr params:params callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToSilverWealthProductDetailButBlockUpWith:obj]);
    }];
}


//载入产品详情
- (void)achieveProductDetailWith:(NSString *)productId
                       callback:(void(^)(id obj))callback {
    NSString *urlStr=[NSString stringWithFormat:@"products/detail/app"];
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"productId"] = productId;
    [self operateSilverFoxDataWith:@"GET" url:urlStr params:param callback:^(id obj)
    {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToSilverWealthProductDetailWith:obj]);
    }];
}

#pragma -mark 我的资产
//获取用户的资产
- (void)obtainUserAssetWithcustomerId:(NSString *)customerId
                         callback:(void(^)(id obj))callback {
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"customerId"]=[NSString stringWithFormat:@"%@",customerId];
    NSString *urlStr=[NSString stringWithFormat:@"assets/content"];
    [self operateSilverFoxDataWith:@"POST" url:urlStr params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToMyAsset:obj]);
    }];
}

- (void)obtainUserAlreadyBindCardListWithcustomerId:(NSString *)customerId
                                            channel:(NSString *)channel
                                           callback:(void(^)(id obj))callback {
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    param[@"channel"] = channel;
    [self operateSilverFoxDataWith:@"POST"
                               url:@"customers/banks"
                            params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToAlreadyBindBankCardWith:obj]);        
    }];
}

//获取用户的银子进出明细
- (void)obtainUserSilverDetailWithcustomerId:(NSString *)customerId
                                        page:(int)page
                                    callback:(void(^)(id obj))callback {
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"page"]=[NSString stringWithFormat:@"%d",page];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST" url:@"assets/silvers/detail" params:param callback:^(id obj) {
        
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseTosilverClear:obj]);
        
    }];
}

//已购产品
- (void)obtainUserAlreadyPurchaseProductWithcustomerId:(NSString *)customerId
                                                  type:(NSString *)type
                                                  page:(int)page
                                              callback:(void(^)(id obj))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = [NSString stringWithFormat:@"%d",page];
    param[@"customerId"] = customerId;
    param[@"type"] = type;
    [self operateSilverFoxDataWith:@"POST" url:@"assets/order" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToAlreadyPurchaseProduct:obj]);
    }];
}

//已购产品详情 
- (void)obtainUserAlreadyPurchaseProductDetailWithOrderNO:(NSString *)orderNO callback:(void(^)(id obj))callback {
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"orderNO"] = orderNO;
    [self operateSilverFoxDataWith:@"POST" url:@"assets/order/detail" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToAlreadyPurchaseProductDetail:obj]);
    }];
}

//获取用户的红包 
- (void)obtainUserRebateWithcustomerId:(NSString *)customerId page:(int)page used:(int)used size:(int)size callback:(void(^)(id obj))callback {
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"used"]=[NSString stringWithFormat:@"%d",used];
    param[@"page"]=[NSString stringWithFormat:@"%d",page];
    param[@"size"]=[NSString stringWithFormat:@"%d",size];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST" url:@"customers/coupons" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToRebate:obj]);
    }];
}

//获取用户夺宝信息
- (void)obtainUserIndianaWithcustomerId:(NSString *)customerId page:(int)page category:(int)category callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"category"] = [NSString stringWithFormat:@"%d",category];
    param[@"page"] = [NSString stringWithFormat:@"%d",page];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"GET" url:@"activities/silvers/race/customer/exchange/goodses" params:param callback:^(id obj) {
        
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper zeroIndianaData:obj]);
    }];
}

// 兑换码
- (void)obtainUserCouponNumberWithcustomerId:(NSString *)customerId  code:(NSString *)code callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"code"] = code;
    param[@"customerId"] = customerId;
    NSString *url=[NSString stringWithFormat:@"customers/coupon/exchange"];
    [self operateSilverFoxDataWith:@"POST" url:url params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];

}

#pragma -mark 更多

//已登录状态 修改登录密码
- (void)modifyLoginPasswordWithcustomerId:(NSString *)customerId
                   oldpassword:(NSString *)oldPassword
                   newpassword:(NSString *)newPassword
                      callback:(void(^)(id obj))callback {
    NSDictionary *param=NSDictionaryOfVariableBindings(customerId,oldPassword,newPassword);
    
    [self operateSilverFoxDataWith:@"POST"
                               url:@"customers/password"
                            params:param callback:^(id obj) {
        
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

//意见反馈
- (void)ideaFeedbackWithContent:(NSString *)content
                       contact:(NSString *)contact
                    phoneModel:(NSString *)phoneModel
                 deviceVersion:(NSString *)deviceVersion
                    appVersion:(NSString *)appVersion
                      callback:(void(^)(id obj))callback {
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    
    param[@"content"]=content;
    if (contact) {
        param[@"contact"]=contact;
    }
    param[@"phoneModel"]=phoneModel;
    param[@"deviceVersion"]=deviceVersion;
    param[@"appVersion"]=appVersion;
    
    [self  operateSilverFoxDataWith:@"POST" url:@"extras/feedback" params:param callback:^(id obj) {
        
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

//签到
- (void)signWithcustomerId:(NSString *)customerId
               callback:(void(^)(id obj))callback {
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"customerId"]=customerId;
    [self operateSilverFoxDataWith:@"POST" url:@"activities/sign" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToUserSign:obj]);
    }];
    
}

//退出登录
- (void)quitLoginWithcustomerId:(NSString *)customerId {
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"PUT" url:@"customers/logout" params:param callback:^(id obj) {
    }];
}

- (void)rollOutOrderNumWithcustomerId:(NSString *)customerId portion:(NSString *)portion productId:(NSString *)productId callback:(void (^)(id))callback {
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    
    params[@"customerId"]=customerId;
    params[@"portion"]=portion;
    params[@"productId"]=productId;
    NSString *url=[NSString stringWithFormat:@"product/baobao/order/redeem"];

    [self operateSilverFoxDataWith:@"POST" url:url params:params callback:^(id obj) {
        
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToRollOutOrderNum:obj]);
    }];
}

#pragma -mark 消息中心 即时查询最新消息

//获取用户历史
- (void)obtainUserHistoryMessageWithcustomerId:(NSString *)customerId
                                       page:(int)page
                                  callback:(void(^)(id obj))callback {
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"page"] = [NSString stringWithFormat:@"%d",page];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST" url:@"customers/message" params:param  callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToUserHistoryMessageList:obj]);
    }];
}

- (void)obtainUserNoReadMessageWithcustomerId:(NSString *)customerId
                                  callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    NSString *url=[NSString stringWithFormat:@"customers/unread/message"];
    [self operateSilverFoxDataWith:@"POST" url:url params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}

- (void)obtainReadAllUserHistoryMessageWithcustomerId:(NSString *)customerId
                                          callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"PUT" url:@"customers/read/messages" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];

}
/**
 *读取消息(单个)
 */
- (void)readUserMessageWithcustomerId:(NSString *)customerId
                            messageId:(NSString *)messageId
                             callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    param[@"messageId"] = messageId;
    [self operateSilverFoxDataWith:@"PUT" url:@"customers/read/message" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

#pragma -mark OAuth 认证
//授权
- (void)OAuthAuthenticationWithclient_id:(NSString *)client_id
                           response_type:(NSString *)response_type
                            redirect_uri:(NSString *)redirect_uri
                                callback:(void(^)(id obj))callback {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"client_id"] = client_id;
    param[@"response_type"] = response_type;
    if (!redirect_uri) {
        param[@"redirect_uri"] = @"https://www.silverfox-cn.com";
    }
    [self operateSilverFoxDataWith:@"POST" url:@"oauth/authorize" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback(obj);
    }];
}
//认证
- (void)OAuthAuthorizationWithclient_id:(NSString *)client_id
                                compact:(NSString *)compact
                          client_secret:(NSString *)client_secret
                                   code:(NSString *)code
                             grant_type:(NSString *)grant_type
                           redirect_uri:(NSString *)redirect_uri
                               callback:(void(^)(id obj))callback {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"client_id"] = client_id;
    param[@"compact"] = compact;
    param[@"client_secret"] = client_secret;
    param[@"code"]=code;
    if (!grant_type) {
        param[@"grant_type"]=@"authorization_code";
    }
    if (!redirect_uri) {
        param[@"redirect_uri"] = @"https://www.silverfox-cn.com";
    }
    [self operateSilverFoxDataWith:@"POST" url:@"oauth/access/token" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback(obj);
    }];
}
//认证刷新
- (void)OAuthAuthorizationUpdateWithclient_id:(NSString *)client_id
                                      compact:(NSString *)compact
                                client_secret:(NSString *)client_secret
                                         code:(NSString *)code
                                   grant_type:(NSString *)grant_type
                                 redirect_uri:(NSString *)redirect_uri
                                refresh_token:(NSString *)refresh_token
                                     callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"client_id"] = client_id;
    param[@"compact"] = compact;
    param[@"client_secret"] = client_secret;
    param[@"code"] = code;
    param[@"refresh_token"] = refresh_token;
    if (!grant_type) {
        param[@"grant_type"] = @"refresh_token";
    }
    if (!redirect_uri) {
        param[@"redirect_uri"] = @"https://www.silverfox-cn.com";
    }
    [self operateSilverFoxDataWith:@"POST" url:@"oauth/access/token" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback(obj);
    }];
}
//检查用户是否购买过某产品
- (void)inspectUserIsAlreadyProductWithProductId:(NSString *)productId customerId:(NSString *)customerId callback:(void(^)(id obj))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"productId"] = productId;
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST" url:@"products/orders/count" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

//使用了邀请红包 分享成功  获取随机红包
- (void)shareSucceedAchieveRebateWithcustomerId:(NSString *)customerId callback:(void(^)(id obj))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST" url:@"more/give/coupon" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}

#pragma -mark 版本检测
- (void)inspectAppVersionWithAppDeviceType:(NSString *)deviceType Callback:(void(^)(id obj))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"deviceType"] = deviceType;
    [self operateSilverFoxDataWith:@"GET" url:@"extras/latest/version" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}

- (void)JiangXiBankDepositoryNoticeWithCallback:(void(^)(id obj))callback
{
    [self operateSilverFoxDataWith:@"GET" url:@"extras/system/notice" params:nil callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}

//银子商城兑换记录
- (void)silverTraderExchangerRecordcustomerId:(NSString *)customerId
                                      page:(int)page
                                  callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    param[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    [self operateSilverFoxDataWith:@"GET" url:@"activities/silvers/store/exchange/record" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper silverTraderExchangeRecord:obj]);
    }];
}
//银子商城赚银子
- (void)silverTraderEarnSilverCallback:(void(^)(id obj))callback
{
    NSString *url=[NSString  stringWithFormat:@"activities/earn/silver/rule"];
    [self operateSilverFoxDataWith:@"GET" url:url params:nil callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper earnSilverInfo:obj]);
    }];
}
//银子商城分享赚银子
- (void)silverTraderShareEarnSilvercustomerId:(NSString *)customerId callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST" url:@"activities/everyday/share" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}
//0元夺宝首界面
- (void)zeroMoneyFirstPage:(int)page
                  callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = [NSString stringWithFormat:@"%d",page];
    [self operateSilverFoxDataWith:@"GET" url:@"activities/silvers/races" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper zeroIndianaData:obj]);
    }];
}

//活动专区界面
- (void)activityZoonWithPage:(int)page
                        size:(int)size
                    callback:(void(^)(id obj))callback
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = [NSString stringWithFormat:@"%d",page];
    param[@"size"] = [NSString stringWithFormat:@"%d",size];
    [self operateSilverFoxDataWith:@"GET" url:@"activities/areas" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper activityZoonData:obj]);
    }];
}


//0元夺宝 夺宝提交页
- (void)IndianaCommitPagecustomerId:(NSString *)customerId
                            goodsId:(NSString *)goodsId
                             portion:(NSString *)portion
                           callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"]=customerId;
    paramss[@"goodsId"]=goodsId;
    paramss[@"portion"]=portion;
    NSString *url=[NSString  stringWithFormat:@"activities/silvers/race/exchange"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper silverTraderExchangeHH:obj]);
    }];
}
/**
 *我的夺宝 详情页
 */
- (void)MyIndianaDetailPagecustomerId:(NSString *)customerId
                           goodsId:(NSString *)goodsId
                          callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss = [NSMutableDictionary dictionary];
    paramss[@"goodsId"] = goodsId;
    paramss[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"GET" url:@"activities/silvers/race/customer/join/codes" params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}
/**
 *我的夺宝 详情页夺宝记录
 */
- (void)MyIndianaRecordWithDetailPageCellphone:(NSString *)cellphone
                                     goodsId:(NSString *)goodsId
                                        page:(int)page
                                    callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss = [NSMutableDictionary dictionary];
    paramss[@"goodsId"] = goodsId;
    paramss[@"cellphone"] = cellphone;
    paramss[@"page"] = [NSString stringWithFormat:@"%d",page];
    [self operateSilverFoxDataWith:@"GET" url:@"activities/silvers/race/exchange/record" params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper myIndianaRecordsInfo:obj]);
    }];
}
//我的夺宝A值
- (void)MyIndianaAWithDetailPageGoodsId:(NSString *)goodsId
                               callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"goodsId"]=goodsId;
    NSString *url=[NSString  stringWithFormat:@"activities/silvers/race/key/a"];
    [self operateSilverFoxDataWith:@"GET" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}
//银子商城 兑换
- (void)silverTraderChangePagecustomerId:(NSString *)customerId
                              goodsId:(NSString *)goodsId
                                 name:(NSString *)name
                            cellphone:(NSString *)cellphone
                              address:(NSString *)address
                             callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"]=customerId;
    paramss[@"goodsId"]=goodsId;
    paramss[@"name"]=name;
    paramss[@"cellphone"]=cellphone;
    paramss[@"address"]=address;
    NSString *url=[NSString  stringWithFormat:@"activities/silvers/goods/exchange"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}
//启动图加载
- (void)startPicturePixels:(NSInteger)pixels callback:(void(^)(id obj))callback{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"pixels"] = [NSString  stringWithFormat:@"%ld",(long)pixels];
    [self operateSilverFoxDataWith:@"GET" url:@"extras/bootstrap/chart" params:param callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper startPicture:obj]);
    }];
}

//回款日历信息
- (void)requestPaymentCalendarDataWithcustomerId:(NSString *)customerId paybackMonth:(NSString *)paybackMonth callback:(void(^)(id obj))callback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"paybackMonth"] = paybackMonth;
    params[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST" url:@"assets/payback/calendar" params:params callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToAlreadyPurchaseProduct:obj]);
    }];
}


//第三方授权登录
- (void)thirdAuthorisationLoginCategory:(NSString *)category
                                 openId:(NSString *)openId
                               nickName:(NSString *)nickName
                                headImg:(NSString *)headImg
                               callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"category"] = category;
    paramss[@"openId"] = openId;
    paramss[@"nickName"] = nickName;
    paramss[@"headImg"] = headImg;
    NSString *url=[NSString  stringWithFormat:@"customers/auth/login"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCustomer:obj]);
    }];
}

/*
 category
 openId
 nickName
 headImg
 cellphone
 password
 login

 */
//第三方授权登录 绑定手机号(已注册)
- (void)thirdAuthorisationLoginWithCustomerCellphone:(NSString *)cellphone
                                            password:(NSString *)password
                                            category:(NSString *)category
                                              openId:(NSString *)openId
                                            nickName:(NSString *)nickName
                                             headImg:(NSString *)headImg
                                               login:(NSString *)login
                                            callback:(void (^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"cellphone"] = cellphone;
    paramss[@"password"] = password;
    paramss[@"category"] = category;
    paramss[@"openId"] = openId;
    paramss[@"nickName"] = nickName;
    paramss[@"headImg"] = headImg;
    paramss[@"login"] = login;
    NSString *url=[NSString  stringWithFormat:@"customers/binding/authorisation"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCustomer:obj]);
    }];
}
//第三方授权登录 绑定手机号(未注册)
- (void)thirdAuthorisationLoginWithUesrCellphone:(NSString *)cellphone
                                            code:(NSString *)code
                                        category:(NSString *)category
                                       channelId:(NSString *)channelId
                                          openId:(NSString *)openId
                                        nickName:(NSString *)nickName
                                         headImg:(NSString *)headImg
                                      deviceUUID:(NSString *)deviceUUID
                                        callback:(void (^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"cellphone"] = cellphone;
    paramss[@"code"] = code;
    paramss[@"category"] = category;
    paramss[@"channelId"] = channelId;
    paramss[@"openId"] = openId;
    paramss[@"nickName"] = nickName;
    paramss[@"headImg"] = headImg;
    paramss[@"deviceUUID"] = deviceUUID;
    NSString *url=[NSString  stringWithFormat:@"customers/auth/register"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToUserRebate:obj]);
    }];
}

//回款短信通知
- (void)paybackSmsResultWithcustomerId:(NSString *)customerId
                               flag:(NSString *)flag
                           callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    paramss[@"flag"] = flag;
    NSString *url=[NSString  stringWithFormat:@"customers/payback/sms"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}


- (void)customerAuthorisationMessageWithcustomerId:(NSString *)customerId
                                       callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    NSString *url=[NSString  stringWithFormat:@"customers/authorisation"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToUserSign:obj]);
    }];
}

//优惠券转赠
- (void)couponGiveToOneWithcustomerId:(NSString *)customerId
                             customerCouponId:(NSString *)customerCouponId
                            cellphone:(NSString *)cellphone
                             callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    paramss[@"customerCouponId"] = customerCouponId;
    paramss[@"cellphone"] = cellphone;
    NSString *url=[NSString  stringWithFormat:@"customers/coupon/donation"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

//理财专栏
- (void)finaacialColumnListWithPage:(int)page
                           callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss = [NSMutableDictionary dictionary];
    paramss[@"page"] = [NSString stringWithFormat:@"%d",page];
    [self operateSilverFoxDataWith:@"GET" url:@"extras/materials" params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToFinanclalConumnList:obj]);
    }];
}

- (void)bindingBankCardWithCustomerId:(NSString *)customerId
                              cardNo:(NSString *)cardNo
                             smsCode:(NSString *)smsCode
                             channel:(NSString *)channel
                            authCode:(NSString *)authCode
                            callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    paramss[@"cardNo"] = cardNo;
    paramss[@"channel"] = channel;
    paramss[@"authCode"] = authCode;
    paramss[@"smsCode"] = smsCode;
    NSString *url=[NSString  stringWithFormat:@"payments/binding/bank"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}


- (void)requestSendSMSMD5KEYWithCallback:(void(^)(id obj))callback
{
//
    NSString *url=[NSString  stringWithFormat:@"extras/sign/key"];
    [self operateSilverFoxDataWith:@"POST" url:url params:nil callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

/**
 *获取交易明细数据
 */
- (void)requestExchageDetailWithCustomerId:(NSString *)customerId
                                      type:(int)type
                                      page:(int)page
                                   history:(int)history
                                    mobile:(int)mobile
                                 startDate:(NSString *)startDate
                                   endDate:(NSString *)endDate
                                  callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    paramss[@"type"] = [NSString stringWithFormat:@"%d",type];
    paramss[@"page"] = [NSString stringWithFormat:@"%d",page];
    paramss[@"history"] = [NSString stringWithFormat:@"%d",history];
    paramss[@"mobile"] = [NSString stringWithFormat:@"%d",mobile];
    paramss[@"startDate"] = startDate;
    paramss[@"endDate"] = endDate;
    NSString *url=[NSString  stringWithFormat:@"assets/transactions"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToExchangeDetail:obj]);
    }];
}

/*
 accountOpenPlus
 cardBindPlus
 mobileModifyPlus
 passwordResetPlus
 directRechargePlus
 indirectRechargePlus
 autoBidAuthPlus
 autoCreditInvestAuthPlus
 */
- (void)requestJXBankSmsCodeWithCellphone:(NSString *)cellphone
                              serviceCode:(NSString *)serviceCode
                                  channel:(NSString *)channel
                                 callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"cellphone"] = cellphone;
    paramss[@"serviceCode"] = serviceCode;
    paramss[@"channel"] = channel;
    NSString *url=[NSString  stringWithFormat:@"customers/bank/sms"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}

- (void)requestRechargeSmsCodeWithUserId:(NSString *)userId
                               cellphone:(NSString *)cellphone
                                 channel:(NSString *)channel
                                callback:(void((^))(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"cellphone"] = cellphone;
    paramss[@"userId"] = userId;
    paramss[@"channel"] = channel;
    NSString *url=[NSString  stringWithFormat:@"customers/recharge/sms"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}

- (void)requestOpenAmountOfJXWithCellphone:(NSString *)cellphone
                                    idcard:(NSString *)idcard
                                   channel:(NSString *)channel
                                      name:(NSString *)name
                                    cardNO:(NSString *)cardNO
                                  authCode:(NSString *)authCode
                                   smsCode:(NSString *)smsCode
                                  callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"cellphone"] = cellphone;
    paramss[@"idcard"] = idcard;
    paramss[@"channel"] = channel;
    paramss[@"name"] = name;
    paramss[@"cardNO"] = cardNO;
    paramss[@"authCode"] = authCode;
    paramss[@"smsCode"] = smsCode;
    NSString *url=[NSString  stringWithFormat:@"customers/open/account"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}


- (void)requestQuickPaymentWithCustomerId:(NSString *)customerId
                                  channel:(NSString *)channel
                                 txAmount:(NSString *)txAmount
                                     type:(NSString *)type
                                  smsCode:(NSString *)smsCode
                                 authCode:(NSString *)authCode
                                cellphone:(NSString *)cellphone
                                 callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss = [NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    paramss[@"channel"] = channel;
    paramss[@"txAmount"] = txAmount;
    paramss[@"type"] = type;
    paramss[@"authCode"] = authCode;
    paramss[@"smsCode"] = smsCode;
    paramss[@"cellphone"] = cellphone;
    NSString *url=[NSString  stringWithFormat:@"payments/recharge"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

- (void)requestUserBalanceAmountWithCustomerId:(NSString *)customerId
                                       channel:(NSString *)channel
                                      callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    paramss[@"channel"] = channel;
    NSString *url=[NSString  stringWithFormat:@"customers/account/balance"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}

- (void)requsetRelieveBankCardWithCustomerId:(NSString *)customerId
                                      cardNo:(NSString *)cardNo
                                     channel:(NSString *)channel
                                    callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    paramss[@"cardNo"] = cardNo;
    paramss[@"channel"] = channel;
    NSString *url=[NSString  stringWithFormat:@"payments/unbinding/bank"];
    [self operateSilverFoxDataWith:@"PUT" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

//
- (void)requestBankLinenoWithCardNO:(NSString *)cardNO
                           callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"cardNO"] = cardNO;
    NSString *url=[NSString  stringWithFormat:@"payments/voucher"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}

- (void)requestFreeTimesWithCustomerId:(NSString *)customerId
                              callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    NSString *url=[NSString  stringWithFormat:@"customers/withdraw/num"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}

- (void)requsetPaymentsWithdrawWithCustomerId:(NSString *)customerId
                                    accountId:(NSString *)accountId
                               provinceBankNO:(NSString *)provinceBankNO
                                       cardNO:(NSString *)cardNO
                                    principal:(NSString *)principal
                                      channel:(NSString *)channel
                                detailChannel:(NSString *)detailChannel
                                     callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    paramss[@"accountId"] = accountId;
    paramss[@"provinceBankNO"] = provinceBankNO;
    paramss[@"principal"] = principal;
    paramss[@"cardNO"] = cardNO;
    paramss[@"channel"] = channel;
    paramss[@"detailChannel"] = detailChannel;
    NSString *url=[NSString  stringWithFormat:@"payments/withdraw/validate"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

- (void)requestConfirmationProductInfoWithCustomerId:(NSString *)customerId
                                                name:(NSString *)name
                                              idcard:(NSString *)idcard
                                             channel:(NSString *)channel
                                           accountId:(NSString *)accountId
                                           productId:(NSString *)productId
                                           principal:(NSString *)principal
                                    customerCouponId:(NSString *)customerCouponId
                                       detailChannel:(NSString *)detailChannel
                                            callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    paramss[@"name"] = name;
    paramss[@"idcard"] = idcard;
    paramss[@"channel"] = channel;
    paramss[@"productId"] = productId;
    paramss[@"principal"] = principal;
    paramss[@"customerCouponId"] = customerCouponId;
    paramss[@"detailChannel"] = detailChannel;
    paramss[@"accountId"] = accountId;
    NSString *url=[NSString  stringWithFormat:@"payments/purchase/validate"];
    [self operateSilverFoxDataWith:@"POST" url:url params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToCode:obj]);
    }];
}

- (void)requestSilverGoodsDataWithCallback:(void(^)(id obj))callback
{
    [self operateSilverFoxDataWith:@"GET" url:@"activities/silvers/store/goodses" params:nil callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToSilverGoods:obj]);
    }];
}


- (void)requestWhetherSetUpTradePasswordAccountId:(NSString *)accountId
                                         callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"accountId"] = accountId;
    [self operateSilverFoxDataWith:@"POST" url:@"payments/password/exist" params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}

- (void)requestRebateActivitiesWithProductId:(NSString *)productId
                                    callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"productId"] = productId;
    [self operateSilverFoxDataWith:@"GET" url:@"products/bonus/strategy/detail" params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToRebateAcitvity:obj]);
    }];
}

- (void)requestIsSuspendShowWithCategory:(NSString *)category
                                callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"category"] = category;
    [self operateSilverFoxDataWith:@"GET" url:@"extras/activity/entrance" params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToFirstPageButton:obj]);
    }];
}

- (void)requestRetroactiveCardListWithCusstomerId:(NSString *)customerId Callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST" url:@"activities/retroactive/cards" params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToRetroactiveCardList:obj]);
    }];
}


- (void)requestProductDetailAndSilverStoreCouponWithCustomerId:(NSString *)customerId
                                                          type:(NSString *)type
                                                      callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    paramss[@"type"] = type;
    [self operateSilverFoxDataWith:@"POST" url:@"customers/vip/relevance" params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}


- (void)requestMemberPrivilegesWithType:(NSString *)type Callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"type"] = [NSNumber numberWithInt:[type intValue]];
    [self operateSilverFoxDataWith:@"GET" url:@"customers/vip/all/welfare" params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}

- (void)requestCollectingOfThePrincipalWithCustomerId:(NSString *)customerId Callback:(void(^)(id obj))callback
{
    NSMutableDictionary *paramss=[NSMutableDictionary dictionary];
    paramss[@"customerId"] = customerId;
    [self operateSilverFoxDataWith:@"POST" url:@"assets/unPaybackPrincipal" params:paramss callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback([ParseHelper parseToError:obj]);
            return;
        }
        callback([ParseHelper parseToDic:obj]);
    }];
}







@end
