//
//  MyAssetCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/3/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MyAssetCell.h"
#import "UILabel+LabelStyle.h"

@implementation MyAssetCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headIM=[[UIImageView alloc] init];
        [self addSubview:_headIM];
        _headIM.contentMode=UIViewContentModeScaleAspectFit;
        [_headIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@25);
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        _nameLB=[[UILabel alloc] init];
        [self addSubview:_nameLB];
        [_nameLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headIM.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@20);
            make.width.equalTo(@200);
        }];
        
        UIImageView *arrowIM=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AllowRight.png"]];
        [self addSubview:arrowIM];
        [arrowIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@7);
            make.height.equalTo(@15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}


-(void)giveValueWithDic:(NSDictionary *)dic {
    [self.headIM setImage:[UIImage imageNamed:dic[@"imageName"]]];
    self.nameLB.text=dic[@"name"];
    
}


@end
