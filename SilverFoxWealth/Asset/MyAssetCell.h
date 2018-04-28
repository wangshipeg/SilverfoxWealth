//
//  MyAssetCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/3/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"


@interface MyAssetCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headIM;
@property (strong, nonatomic) UILabel *nameLB;


-(void)giveValueWithDic:(NSDictionary *)dic;


@end
