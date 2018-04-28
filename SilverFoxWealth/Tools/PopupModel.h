//
//  PopupModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/10/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface PopupModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *idStr;//优惠券id
//@property (nonatomic, strong) NSString *name;//优惠券名字
@property (nonatomic, strong) NSString *amount;//优惠券金额
@property (nonatomic, strong) NSString *condition;//使用条件
@property (nonatomic, strong) NSString *category;//类型 0 - 红包 1-加息券

/**
 *id:1,
 amount:3,
 condition:”使用条件”,
 category:1//0:红包，1：加息券
 */

@end
