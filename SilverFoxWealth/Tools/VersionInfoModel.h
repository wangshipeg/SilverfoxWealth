//
//  VersionInfoModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/8/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface VersionInfoModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *idStr;          //版本信息id
@property (nonatomic, strong) NSString *versionNumber;  //版本号
@property (nonatomic, strong) NSString *upgradeContent; //更新内容
@property (nonatomic, strong) NSString *status;         //状态
@property (nonatomic, strong) NSString *url;            //更新地址
@property (nonatomic, strong) NSString *upgradeType;    //optional compulsive 更新方式


@end
