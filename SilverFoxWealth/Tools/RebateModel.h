//
//  RebateModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
/*
 id
 source
 condition
 amount
 financePeriod
 cumulative
 category
 expiresPoint
 */

@interface RebateModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *amount; //金额
@property (nonatomic, strong) NSString *source;//红包来源
@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *condition;//红包使用条件
@property (nonatomic, strong) NSString *financePeriod;//理财期限限制
@property (nonatomic, strong) NSString *cumulative; //是否累加 0是非累加 1是累加
@property (nonatomic, strong) NSString *category;//0-3为红包  4 5为加息券
@property (nonatomic, strong) NSString *expiresPoint;//红包到期时间
@property (nonatomic, strong) NSString *used;//已失效红包返回  0-已过期 1-已使用
@property (nonatomic, strong) NSString *donation; // 0不可转赠 1可转增
@property (nonatomic, strong) NSString *moneyLimit;//0 不限制  1-单笔满多少可用 2-累计满多少可用
@property (nonatomic, strong) NSString *tradeAmount;//moneyLimit的金额
@property (nonatomic, strong) NSString *increaseDays;//加息券加息天数


@end










