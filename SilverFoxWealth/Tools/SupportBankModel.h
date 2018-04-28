//
//  SupportBankModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

//连连支持的 支付银行 的model

@interface SupportBankModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *cardType; //银行种类  储蓄卡 还是 信用卡
@property (nonatomic, strong) NSString *bankId; //银行id
@property (nonatomic, strong) NSString *bankName; //银行名称
@property (nonatomic, strong) NSString *remark; //限额
@property (nonatomic, strong) NSString *serialNO; //银行唯一标识
@property (nonatomic, strong) NSString *enable;
//    cardType = "\U501f\U8bb0\U5361";
//    id = 14;
//    name = "\U5e7f\U53d1\U94f6\U884c";
//    remark = "50\U4e07/100\U4e07/\U65e0\U9650\U989d";
//    serialNO = 03060000;
//    servicePhone = 95508;

@end
