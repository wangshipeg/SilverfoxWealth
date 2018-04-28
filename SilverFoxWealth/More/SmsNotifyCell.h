//
//  SmsNotifyCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/2/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CustomerSeparateTableViewCell.h"

typedef void (^isOpenSmsPassword)(BOOL isOpen);
@interface SmsNotifyCell : UITableViewCell

@property (strong, nonatomic) UISwitch *smsSwitch;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, copy) isOpenSmsPassword openSmsBlock;

- (void)openSMSNotifyWith:(isOpenSmsPassword)paOpenBlock;

@end
