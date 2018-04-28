//
//  SCMeasure.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SCMeasureDump.h"
#import "PromptLanguage.h"
#import "SCMeasureDump.h"
#import "IndividualInfoManage.h"
#import "DataRequest.h"
#import "SCMeasureResult.h"
#import "RequestOAth.h"
#import <SVProgressHUD.h>
#import "ConversionString.h"
#import "WithoutAuthorization.h"

@implementation SCMeasureDump
+ (instancetype)shareSCMeasureDump {
    static SCMeasureDump *sheredClient=NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sheredClient = [[SCMeasureDump alloc] init];
    });
    return sheredClient;
}

- (void)achieveSignStringWith:(void(^)(NSString *resultStr))callBack {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] requestSendSMSMD5KEYWithCallback:^(id obj) {
        DLog(@"sign结果======%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=obj;
            NSString *keyStr=[dic objectForKey:@"key"];
            NSString *signStr=[dic objectForKey:@"sign"];
            if (SHARE_SCMEASURERESULT -> isRightSignStr(keyStr,signStr)) {
                const char *targetChar=[keyStr cStringUsingEncoding:NSUTF8StringEncoding];
                int len=(int)strlen(targetChar)+1;
                char buf[len];
                revert(targetChar,buf);
                NSString *resultStr=[NSString stringWithFormat:@"%s",buf];
                callBack(resultStr);
            }else {
                callBack(nil);
            }
        }
        //需要授权
        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
            [RequestOAth authenticationWithclient_id:user.cellphone response_type:@"code" callback:^(BOOL succeedState) {
                if (succeedState) {
                    [self achieveSignStringWith:callBack];
                }
                //请求错误
                if (!succeedState) {
                    callBack(nil);
                }
            }];
        }
    }];
}

//- (void)achieveSignRegStringWith:(void(^)(NSString *resultStr))callBack;
//{
//    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
//    [[DataRequest sharedClient] achieveSignRegStringWithCallback:^(id obj) {
//        DLog(@"sign结果======%@",obj);
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic=obj;
//            NSString *keyStr=[dic objectForKey:@"key"];
//            NSString *signStr=[dic objectForKey:@"sign"];
//            if (SHARE_SCMEASURERESULT -> isRightSignStr(keyStr,signStr)) {
//                const char *targetChar=[keyStr cStringUsingEncoding:NSUTF8StringEncoding];
//                int len=(int)strlen(targetChar)+1;
//                char buf[len];
//                revert(targetChar,buf);
//                NSString *resultStr=[NSString stringWithFormat:@"%s",buf];
//                callBack(resultStr);
//            }else {
//                callBack(nil);
//            }
//        }
//        //需要授权
//        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
//            [RequestOAth authenticationWithclient_id:user.customerId response_type:@"code" callback:^(BOOL succeedState) {
//                if (succeedState) {
//                    [self achieveSignStringWith:callBack];
//                }
//                //请求错误
//                if (!succeedState) {
//                    callBack(nil);
//                }
//            }];
//        }
//        if ([obj isKindOfClass:[NSError class]]) {
//        }
//    }];
//}

@end
