//
//  EarnSilverCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CustomerSeparateTableViewCell.h"
#import "EarnSilversModel.h"
typedef void(^PlayTaskBlock)();

@interface EarnSilverCell : CustomerSeparateTableViewCell

/**
 *赚银子
 */

@property (nonatomic, strong) UILabel *nameLB;//任务名称
@property (nonatomic, strong) UILabel *rewardLB;//奖励
@property (nonatomic, strong) UIButton *playTaskBT;//做任务

@property (nonatomic, copy) PlayTaskBlock taskBlock;

- (void)plcyTaskBlock:(PlayTaskBlock)taskBlock;
- (void)showEarnSilversDataWithDic:(EarnSilversModel *)data;
@end



