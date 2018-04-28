//
//  ZeroIndianaModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface ZeroIndianaModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *stock;//总共可以参与次数
@property (nonatomic, strong) NSString *joinNum;//已经参与次数
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *consumeSilver;
/**
 *id:1
 name:”天堂伞”
 url:”图片地址”
 stock:3//库存
 consumeSilver:1000
 joinNum:3//已购份数
 */
@end





