//
//  MyMessageCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
#import "SystemInfoModel.h"


@interface MyMessageCell : UITableViewCell

@property (strong, nonatomic) UILabel *messageFromLB;
@property (strong, nonatomic) UILabel *messageTimeLB;
@property (strong, nonatomic) UILabel *messageContentLB;


//显示用户消息
- (void)showMessageWith:(UserInfoModel *)dic;

- (CGFloat)achieveContentHeight;

//更新颜色
//- (void)updateContentColorWith:(BOOL)isRead;


@end
