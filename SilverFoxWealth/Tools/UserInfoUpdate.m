//
//  UserInfoUpdate.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UserInfoUpdate.h"
#import "DataRequest.h"
#import "VCAppearManager.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "UserDefaultsManager.h"
#import "WithoutAuthorization.h"
#import "CacheHelper.h"


@implementation UserInfoUpdate


//更新用户信息
+ (void)updateUserInfoWithTargerVC:(UIViewController *)targerVC {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        DLog(@"即时获取用户信息结果====%@",obj);
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser=obj;
            [IndividualInfoManage updateAccountWith:resultUser];
        }
    }];
}

//清除用户本地消息
+ (void)clearUserLocalInfo {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
    //删除我的资产表  其它表不用删
    [CacheHelper removeAssetData];
    [IndividualInfoManage removeAccount];
}


@end
