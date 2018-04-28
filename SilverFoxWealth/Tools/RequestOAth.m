
#import "RequestOAth.h"
#import "DataRequest.h"
#import "ParseHelper.h"
#import "EncryptHelper.h"
#import "UserDefaultsManager.h"
#import "SCMeasureDump.h"

@implementation RequestOAth

//授权
+ (void)authenticationWithclient_id:(NSString *)client_id response_type:(NSString *)response_type callback:(void(^)(BOOL succeedState))callback
{
    [[DataRequest sharedClient] OAuthAuthenticationWithclient_id:client_id response_type:response_type redirect_uri:nil callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback(NO);
            return ;
        }
        NSString *codeStr=[ParseHelper parseToAuthenticationDic:obj];
        if (!codeStr) {
            callback(NO);
            return;
        }
        //授权结束 就去认证 认证结束 回调认证结果
        NSString *client_secretStr = [EncryptHelper MD5String:client_id];
        [self authorizationWithclient_id:client_id client_secret:client_secretStr code:codeStr callback:^(id obj) {
            if ([obj isKindOfClass:[NSError class]]) {
                callback(NO);
                return ;
            }
            //认证成功 回调
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = obj;
                //清除旧的 保存新的
                [UserDefaultsManager clearUserApiKey];
                [UserDefaultsManager saveUserApiKey:[NSString stringWithFormat:@"%@ %@",dict[@"token_type"],dict[@"access_token"]]];
                [UserDefaultsManager clearUserExpriresIn];
                [UserDefaultsManager saveUserAuthExpriresIn:dict[@"access_token"]];
                [UserDefaultsManager clearUserRefreshToken];
                [UserDefaultsManager saveUserRefreshToken:dict[@"refresh_token"]];
                callback(YES);
            }else{
                callback(NO);
            }
        }];
    }];
}

//认证
+ (void)authorizationWithclient_id:(NSString *)client_id client_secret:(NSString *)client_secret code:(NSString *)code callback:(void(^)(id obj))callback
{
    [[DataRequest sharedClient] OAuthAuthorizationWithclient_id:client_id compact:code client_secret:client_secret code:code grant_type:nil redirect_uri:nil callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback(obj);
            return ;
        }
        id dataDic = [ParseHelper parseToAuthorizationDic:obj];
        if ([dataDic isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = dataDic;
            NSString *access_tokenStr = dict[@"access_token"];
            [SCMeasureDump shareSCMeasureDump].accessTokenStr = access_tokenStr;
        }
        callback(dataDic);
    }];
}

//刷新认证
+ (void)authenticationUpdateWithclient_id:(NSString *)client_id response_type:(NSString *)response_type callback:(void(^)(BOOL succeedState))callback
{
    NSString *client_secretStr = [EncryptHelper MD5String:client_id];
    [self authorizationWithclient_id:client_id client_secret:client_secretStr code:[UserDefaultsManager searchAuthExpiresIn] refresh_token:[UserDefaultsManager searchUserRefreshToken] callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback(NO);
            return ;
        }
        //认证成功 回调
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = obj;
            [UserDefaultsManager clearUserApiKey];
            [UserDefaultsManager saveUserApiKey:[NSString stringWithFormat:@"%@ %@",dict[@"token_type"],dict[@"access_token"]]];
            [UserDefaultsManager clearUserExpriresIn];
            [UserDefaultsManager saveUserAuthExpriresIn:dict[@"access_token"]];
            [UserDefaultsManager clearUserRefreshToken];
            [UserDefaultsManager saveUserRefreshToken:dict[@"refresh_token"]];
            callback(YES);
        } else {
            callback(NO);
        }
    }];
}

+ (void)authorizationWithclient_id:(NSString *)client_id client_secret:(NSString *)client_secret code:(NSString *)code refresh_token:(NSString *)refresh_token callback:(void(^)(id obj))callback
{
    [[DataRequest sharedClient] OAuthAuthorizationUpdateWithclient_id:client_id compact:code client_secret:client_secret code:code grant_type:nil redirect_uri:nil refresh_token:refresh_token callback:^(id obj) {
        if ([obj isKindOfClass:[NSError class]]) {
            callback(obj);
            return ;
        }
        id dataDic = [ParseHelper parseToAuthorizationDic:obj];
        if ([dataDic isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = dataDic;
            NSString *access_tokenStr = dict[@"access_token"];
            [SCMeasureDump shareSCMeasureDump].accessTokenStr = access_tokenStr;
        }
        callback(dataDic);
    }];
}



@end






