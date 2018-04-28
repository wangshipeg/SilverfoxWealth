//
//  MoreSetTopThreeCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/8/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MoreSetTopThreeCell.h"
#import "UILabel+LabelStyle.h"

@implementation MoreSetTopThreeCell

- (id)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        
        UIImageView *imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@25);
            make.height.equalTo(@25);
        }];
        
        UILabel *titleLB=[[UILabel alloc] init];
        [self addSubview:titleLB];
        titleLB.text=title;
        [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(51);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@70);
            make.height.equalTo(@20);
        }];
        
        
    }
    return self;
}


@end
