//
//  MyBankCardListCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankAndIdentityInfoModel.h"

@interface MyBankCardListCell : UITableViewCell
@property (strong, nonatomic) UIImageView *headIM; //银行icon图
@property (strong, nonatomic) UILabel     *nameAndCardNumLB; //银行名字和账号

-(void)showDetailWithDic:(BankAndIdentityInfoModel *)dic;

@end
