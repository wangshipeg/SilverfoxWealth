//
//  SilverGoodsLeightModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface SilverGoodsLeightModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cellphone;

@end
