//
//  MyBonusOneCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

//累加红包cell
#import <UIKit/UIKit.h>
#import "RebateModel.h"
#import "CustomerSeparateTableViewCell.h"
#import "SilverWealthProductDetailModel.h"


typedef void (^EnterRebateDetailBlock)();

@interface MyBonusOneCell : UITableViewCell
@property (strong, nonatomic) UIImageView *headIM;
@property (nonatomic, strong) UILabel  *amountTitleLB;//邀请好友累积奖励
@property (nonatomic, strong) UILabel  *useNoteLB;//使用说明
@property (nonatomic, strong) UIButton *seeDetailBT;//查看明细
@property (nonatomic, strong) UILabel  *cumulativeLB;//累积红包金额LB


@property (nonatomic, copy  ) EnterRebateDetailBlock enterDetailBlock;

- (void)showCumulativeRebate:(RebateModel *)data;

@end
