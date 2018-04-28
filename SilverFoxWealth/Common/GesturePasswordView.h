//
//  GesturePasswordView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "TentacleView.h"
@interface GesturePasswordView : UIView<TouchBeginDelegate>

@property (nonatomic, strong) TentacleView *tentacleView;
@property (nonatomic, strong) UILabel *state;
























@end
