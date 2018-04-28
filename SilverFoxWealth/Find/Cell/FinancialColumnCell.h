//
//  FinancialColumnCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CustomerSeparateTableViewCell.h"
#import "FinancialColumnModel.h"

@interface FinancialColumnCell : CustomerSeparateTableViewCell

@property (nonatomic, strong) UIImageView *contentImage;//缩略图
@property (nonatomic, strong) UILabel *contentNameLB;//名称
@property (nonatomic, strong) UILabel *contentSummaryLB;//内容摘要

- (void)showFinancialColumnList:(FinancialColumnModel *)dic;

@end
