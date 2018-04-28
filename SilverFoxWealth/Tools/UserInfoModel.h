//
//  UserInfoModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/8/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface UserInfoModel : MTLModel<MTLJSONSerializing>
/*
 title: 到期回款;
 createTime : 2017-03-13 09:09:09;
 id : 105;
 status : 0;
 message : "亲爱的用户…..";
 
 */
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *createTime; //创建时间
@property (nonatomic, strong) NSString *idStr;  //消息id
@property (nonatomic, strong) NSString *message; //消息内容
@property (nonatomic, strong) NSString *status;// 0未读 1已读

@end
