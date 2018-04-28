//
//  ProductDetailRebateCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackRebateActivityModel.h"

@interface ProductDetailRebateCell : UITableViewCell
@property (nonatomic, strong) UILabel *moneyLB;
@property (nonatomic, strong) UILabel *infomationLB;

- (void)showProductDetailRebateList:(BackRebateActivityModel *)dict;
@end

