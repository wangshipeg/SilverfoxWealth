//
//  MyBonusCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

//普通红包 cell
#import <UIKit/UIKit.h>
#import "RebateModel.h"
#import "CustomerSeparateTableViewCell.h"
#import "SilverWealthProductDetailModel.h"


@interface MyBonusCell : UITableViewCell
@property (strong, nonatomic) UILabel     *rebateFromLB;//红包来源
@property (nonatomic, strong) UIImageView *lineImg;//中间虚线
@property (strong, nonatomic) UIImageView *headIM;
@property (strong, nonatomic) UILabel     *amountNumLB;
@property (nonatomic, strong) UILabel     *sixtyDaysTimeLimitLB; //提示60天以上可用(使用期限)
@property (nonatomic, strong) UILabel  *giveToOneLB;//转赠
@property (nonatomic, strong) UILabel *useTimeLimitLB;//使用条件
@property (nonatomic, strong) UILabel *increaseTime;//加息时间
@property (nonatomic, strong) UIImageView *isPasseImg;//过期还是已使用

- (void)showRebateDetailWith:(RebateModel *)data currentTotalTradeMoney:(NSString *)currentTotalTradeMoney;
- (void)showCanNotUseRebateDetailWith:(RebateModel *)data;


@end
