//
//  FindHotActivityCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CustomerSeparateTableViewCell.h"

@interface FindHotActivityCell : UITableViewCell
@property (nonatomic, strong) UIImageView *phoneImg;//展示图
@property (nonatomic, strong) UILabel *nameLB;//名称
@property (nonatomic, strong) UILabel *statusLB;//状态
@property (nonatomic, strong) UIView *viewAlpha;

- (instancetype)initWithOtherReuseIdentifier:(NSString *)reuseIdentifier;
@end
