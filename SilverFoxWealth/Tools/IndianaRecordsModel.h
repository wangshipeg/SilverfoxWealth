//
//  IndianaRecordsModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface IndianaRecordsModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *cellphone;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *joinCode;
/**
 *cellphone:”13888888888”
 raceTime:”yyyy-MM-dd hh:mm:ss”
 raceCount:3

 */
@end
