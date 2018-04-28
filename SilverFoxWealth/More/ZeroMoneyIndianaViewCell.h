//
//  ZeroMoneyIndianaViewCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZeroIndianaModel.h"

@interface ZeroMoneyIndianaViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *phoneImg;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UILabel *statusLB;
@property (nonatomic, strong) UILabel *residueLB;//剩余份数
@property (nonatomic, strong) UIView *viewAlpha;
@property (nonatomic, strong) UIProgressView *purchasePregress;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)showIndinanPageWith:(ZeroIndianaModel *)dic;

@end
