//
//  MyIndianaCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIndianaCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *phoneImg;//展示图
@property (nonatomic, strong) UILabel *nameLB;//名称
@property (nonatomic, strong) UILabel *statusLB;//状态
@property (nonatomic, strong) UILabel *residueLB;//剩余份数
@property (nonatomic, strong) UIView *viewAlpha;

@end
