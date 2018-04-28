//
//  EarnSilversModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface EarnSilversModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSString *name;//任务标题
@property (nonatomic, strong) NSString *type;//任务类型 1一般任务 2每日任务
@property (nonatomic, strong) NSString *content;//分享文案
@property (nonatomic, strong) NSString *idStr;//1问卷调查 2签到 3每日分享 4投资送银子
@property (nonatomic, strong) NSString *shareContent;//分享文案

@property (nonatomic, strong) NSString *shareTitle;//分享的新闻标题
@property (nonatomic, strong) NSString *shareType;//分享类型 1内部上传shareId 2外部链接link
@property (nonatomic, strong) NSString *outLink;//分享界面的链接地址
@property (nonatomic, strong) NSString *shareId;//分享界面的链接地址 


/**
 *
 id:1
 name:”问卷调查”,
 type:1,//1:常规任务，其他的为非常规任务
 content:”描述”,
 address:”http://baidu.com”,//每日任务地址
 shareContent:”分享文案”,
 newsId:1,
 newsType:1,//1：内部上传2：外部链接
 outLink:”http://baidu.com”//外部链接地址
 */

@end
