//
//  ShareConfig.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShareConfig.h"
#import "EncryptHelper.h"
#import "UMMobClick/MobClick.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"
#import "IndividualInfoManage.h"
#import "StringHelper.h"


@implementation ShareConfig

+ (void)uMengContentConfigWithCellPhone:(NSString *)cellPhone tag:(NSInteger )tag presentVC:(UIViewController *)presentVC shareContent:(NSString *)shareContent shareImage:(UIImage *)shareImage title:(NSString *)title userUrlStr:(NSString *)userUrlStr succeedCallback:(void(^)())succeedCallback {
    
    UIImage *image=[UIImage imageNamed:@"AppLogo.png"];
    if (tag==1||tag==2) {
        if (![WXApi isWXAppInstalled]) {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备没有安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    }
    
    //微信好友
    if (tag==1) {
        [MobClick event:@"share_to_weixin"];
        [[SensorsAnalyticsSDK sharedInstance] track:@"Share"
                                     withProperties:@{
                                                      @"ShareWay" : @"微信",
                                                      }];
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:shareContent thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = userUrlStr;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:presentVC completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    if (succeedCallback) {
                        succeedCallback();
                    }
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            //[self alertWithError:error];
        }];
    }
    
    //朋友圈
    if (tag==2) {
        [MobClick event:@"share_to_weixin_circle"];
        [[SensorsAnalyticsSDK sharedInstance] track:@"Share"
                                     withProperties:@{
                                                      @"ShareWay" : @"朋友圈",
                                                      }];
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareContent descr:shareContent thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = userUrlStr;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:presentVC completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            } else {
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    if (succeedCallback) {
                        succeedCallback();
                    }
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }
    
    if (tag==4||tag==5) {
        if (![TencentApiInterface isTencentAppInstall:kIphoneQQ] && ![TencentApiInterface isTencentAppSupportTencentApi:kIphoneQQ]) {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备没有安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    }
    
    //QQ
    if (tag==4) {
        [MobClick event:@"share_to_QQ"];
        [[SensorsAnalyticsSDK sharedInstance] track:@"Share"
                                     withProperties:@{
                                                      @"ShareWay" : @"QQ",
                                                      }];
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:shareContent thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = userUrlStr;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:presentVC completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    if (succeedCallback) {
                        succeedCallback();
                    }
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }
    
    //QQ空间
    if (tag==5) {
        [MobClick event:@"share_to_QQ_zone"];
        [[SensorsAnalyticsSDK sharedInstance] track:@"Share"
                                     withProperties:@{
                                                      @"ShareWay" : @"QQ空间",
                                                      }];
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:shareContent thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = userUrlStr;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Qzone messageObject:messageObject currentViewController:presentVC completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    if (succeedCallback) {
                        succeedCallback();
                    }
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
        
    }
    
    //新浪微博
    if (tag==3) {
        [MobClick event:@"share_to_sina_wb"];
        [[SensorsAnalyticsSDK sharedInstance] track:@"Share"
                                     withProperties:@{
                                                      @"ShareWay" : @"新浪微博",
                                                      }];
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:shareContent thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = userUrlStr;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:presentVC completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            } else {
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    if (succeedCallback) {
                        succeedCallback();
                    }
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                } else {
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }
    
    //短信分享
    if (tag==0) {
        [MobClick event:@"share_to_sms"];
        [[SensorsAnalyticsSDK sharedInstance] track:@"Share"
                                     withProperties:@{
                                                      @"ShareWay" : @"短信",
                                                      }];
        NSString *deviceType=[UIDevice currentDevice].model;
        if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:@"您的设备不能发送短信" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //分享消息对象设置分享内容对象
        messageObject.text = shareContent;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sms messageObject:messageObject currentViewController:presentVC completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    if (succeedCallback) {
                        succeedCallback();
                    }
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            //[self alertWithError:error];
        }];
    }
}

@end




