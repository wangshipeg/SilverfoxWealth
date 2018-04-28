//
//  SmsNotifyCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/2/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SmsNotifyCell.h"
#import "UILabel+LabelStyle.h"
#import "DataRequest.h"
#import "IndividualInfoManage.h"

@implementation SmsNotifyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLB=[[UILabel alloc] init];
        [self addSubview:_titleLB];
        [_titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@20);
            make.width.equalTo(@120);
        }];
        
        _smsSwitch = [[UISwitch alloc] init];
        [self addSubview:_smsSwitch];
        [_smsSwitch setOn:NO];
        [_smsSwitch addTarget:self action:@selector(isGesture:) forControlEvents:UIControlEventValueChanged];
        [_smsSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
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
            _openSmsBlock(NO);
        }else{ //如果开启时 就去设置手势密码
            _openSmsBlock(YES);
        }
    }
}

- (void)openSMSNotifyWith:(isOpenSmsPassword)paOpenBlock
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser=obj;
            //更新用户信息
            [IndividualInfoManage updateAccountWith:resultUser];
            if ([resultUser.sendMessage integerValue] == 0) {
                [self.smsSwitch setOn:YES];
            } else {
                [self.smsSwitch setOn:NO];
            }
            _openSmsBlock = paOpenBlock;
        }
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
