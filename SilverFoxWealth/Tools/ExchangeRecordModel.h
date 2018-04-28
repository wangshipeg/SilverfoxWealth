//
//  ExchangeRecordModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <Mantle/Mantle.h>
/*
 "amount": 100,
 "purpose": "到期回款-榜单活动60",
 "tradeTime": "2017-06-01 00:00:00",
 */
@interface ExchangeRecordModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *purpose;
@property (nonatomic, strong) NSString *tradeTime;

@end
