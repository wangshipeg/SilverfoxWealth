//
//  PasswordManageTwoCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PasswordManageTwoCell.h"
#import "GesturePasswordVC.h"
//#import "KeychainItemWrapper.h"
#import "UserDefaultsManager.h"
#import "UILabel+LabelStyle.h"
#import "DataRequest.h"

@implementation PasswordManageTwoCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLB=[[UILabel alloc] init];
        [self addSubview:_titleLB];
        [_titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor characterBlackColor]];
        [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@20);
            make.width.equalTo(@100);
        }];
        
        _gestureSwitch=[[UISwitch alloc] init];
        [self addSubview:_gestureSwitch];
        [_gestureSwitch setOn:NO];
        [_gestureSwitch addTarget:self action:@selector(isGesture:) forControlEvents:UIControlEventValueChanged];
        [_gestureSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
    }
    return self;
}


- (void)isGesture:(UISwitch *)sender {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (user) {
        //如果关闭或开启时 通过块把关闭事件传出去
        if (!sender.on) {
            _openBlock(NO);
        }else{ //如果开启时 就去设置手势密码
            _openBlock(YES);
        }
    }
}

- (void)openGesturePasswordWith:(isOpenGesturePassword)paOpenBlock {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (user) {
        if ([UserDefaultsManager  gesturePasswordIsExistWith:user.customerId]) {
            self.gestureSwitch.on = YES;
        }else {
            [self.gestureSwitch setOn:NO];
        }
    }
    _openBlock = paOpenBlock;
}






@end
