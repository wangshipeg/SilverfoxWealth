//
//  NoRightArrowCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NoRightArrowCell.h"
#import "UILabel+LabelStyle.h"

@implementation NoRightArrowCell
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (id)initWithTitle:(NSString *)title {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        
        
        UILabel *titleLB=[[UILabel alloc] init];
        [self addSubview:titleLB];
        titleLB.text=title;
        [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@250);
            make.height.equalTo(@20);
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
