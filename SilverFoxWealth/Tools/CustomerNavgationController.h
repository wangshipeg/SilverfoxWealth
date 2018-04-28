//
//  CustomerNavgationController.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerNavgationController : UIView
@property (nonatomic, copy) void(^leftViewController)(void);
@property (nonatomic, copy) void(^rightButtonHandle)(void);

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@end
