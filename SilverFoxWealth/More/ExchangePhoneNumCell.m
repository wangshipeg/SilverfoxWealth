//
//  ExchangePhoneNumCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ExchangePhoneNumCell.h"
#import "UILabel+LabelStyle.h"

@implementation ExchangePhoneNumCell
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (id)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        
        UIImageView *imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self addSubview:imageV];
        imageV.contentMode=UIViewContentModeScaleAspectFit;
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
            make.width.equalTo(@200);
            make.height.equalTo(@20);
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
