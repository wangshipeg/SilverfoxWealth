//
//  ExchangerRecordModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface ExchangerRecordModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *exchangeTime;//兑换时间
@property (nonatomic, strong) NSString *goodsName;//商品名称
@property (nonatomic, strong) NSString *cost;//消耗银子数
@property (nonatomic, strong) NSString *thirdPartyNO;//兑换码
@property (nonatomic, strong) NSString *url;//缩略图地址
@property (nonatomic, strong) NSString *type;


@end
