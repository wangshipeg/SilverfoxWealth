//
//  BackRebateActivityModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BackRebateActivityModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *full;
@property (nonatomic, strong) NSString *back;
@property (nonatomic, strong) NSString *increaseDays;

@end
