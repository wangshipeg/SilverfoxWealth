//
//  LastTimeUseBankModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/3/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface LastTimeUseBankModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *singleLimit;//单笔限额
@property (nonatomic, strong) NSString *dayLimit;//单日
@property (nonatomic, strong) NSString *monthLimit;
@property (nonatomic, strong) NSString *bankName;//
@property (nonatomic, strong) NSString *cardNO;
@property (nonatomic, strong) NSString *bankNO;
@property (nonatomic, strong) NSString *status;

@end
