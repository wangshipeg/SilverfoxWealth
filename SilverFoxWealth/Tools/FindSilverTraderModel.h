//
//  FindSilverTraderModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface FindSilverTraderModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *consumeSilver;
//@property (nonatomic, strong) NSString *sortNumber;
@property (nonatomic, strong) NSString *stock;
@property (nonatomic, strong) NSString *type;//1:虚拟商品2：实物商品3：第三方券码
//@property (nonatomic, strong) NSString *largerUrl;
//@property (nonatomic, strong) NSString *remark;
//@property (nonatomic, strong) NSString *rule;
//@property (nonatomic, strong) NSString *silver;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *achieveAmount;
@property (nonatomic, strong) NSString *vipDiscount;
/**
 id
 name
 url
 stock
 consumeSilver
 type
 hot
 category
 discount
 isShow
 */
@end
