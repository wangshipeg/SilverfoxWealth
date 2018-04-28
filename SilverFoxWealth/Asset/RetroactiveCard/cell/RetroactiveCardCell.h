//
//  RetroactiveCardCell.h
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetroactiveCardModel.h"

@interface RetroactiveCardCell : UITableViewCell

/** imageView */
@property (nonatomic, strong) UIImageView *imgView;

/** BGImageView */
@property (nonatomic, strong) UIImageView *bgImgView;

/** title */
@property (nonatomic, strong) UILabel *titleLabel;

/** timeLabel */
@property (nonatomic, strong) UILabel *timeLabel;

/** useBtn */
@property (nonatomic, strong) UIButton *useBtn;

/** model */
@property (nonatomic, strong) RetroactiveCardModel *model;

@end
