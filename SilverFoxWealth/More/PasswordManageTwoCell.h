//
//  PasswordManageTwoCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSeparateTableViewCell.h"


typedef void (^isOpenGesturePassword)(BOOL isOpen);

@interface PasswordManageTwoCell : UITableViewCell

@property (strong, nonatomic) UISwitch *gestureSwitch;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, copy) isOpenGesturePassword openBlock;

- (void)openGesturePasswordWith:(isOpenGesturePassword)paOpenBlock;

@end
