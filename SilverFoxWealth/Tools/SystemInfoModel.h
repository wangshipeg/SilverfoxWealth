//
//  SystemInfoModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/8/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface SystemInfoModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *idStr;  //消息id
@property (nonatomic, strong) NSString *title;  //系统消息标题
@property (nonatomic, strong) NSString *createTime; //创建时间

@property (nonatomic, strong) NSString *type;    //新闻类型，1：内部上传，2：外部链接
@property (nonatomic, strong) NSString *link;    //外部链接 如果是外部链接 打开这个链接
@property (nonatomic, strong) NSString *newsId;  //新闻id  如果是内部上传 把这个值拼接到地址后面
@property (nonatomic, strong) NSString *status;//0 未读 1 已读
@property (nonatomic, strong) NSString *shareDesc;


@end
