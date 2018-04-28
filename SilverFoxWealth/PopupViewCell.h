//
//  PopupViewCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/10/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupModel.h"
@interface PopupViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backgroundImg;
@property (nonatomic, strong) UILabel *amountLB;
@property (nonatomic, strong) UILabel *useLimitLB;

- (void)showRebateDetailWith:(PopupModel *)data;

@end
