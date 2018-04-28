//
//  RetroactiveCardModel.h
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Mantle/Mantle.h>
/*
 "id": 1,
 "useTime": "1970-01-01",
 "expireTime": "1970-01-01",
 "receiveTime": "1970-01-01",
 "customerId": 6645985
 */


@interface RetroactiveCardModel : MTLModel
/** id */
@property (nonatomic, copy) NSString *retroactiveCardId;

/** useTime */
@property (nonatomic, copy) NSString *useTime;

/** expireTime */
@property (nonatomic, copy) NSString *expireTime;

/** receiveTime */
@property (nonatomic, copy) NSString *receiveTime;

/** customerId */
@property (nonatomic, copy) NSString *customerId;

@end
