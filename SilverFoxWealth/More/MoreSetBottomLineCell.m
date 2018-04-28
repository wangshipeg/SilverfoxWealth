//
//  MoreSetBottomLineCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/1/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MoreSetBottomLineCell.h"
#import "UILabel+LabelStyle.h"

@implementation MoreSetBottomLineCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (id)initWithTitle:(NSString *)title {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        
//        UIImageView *imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//        [self addSubview:imageV];
//        imageV.contentMode=UIViewContentModeScaleAspectFit;
//        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(15);
//            make.centerY.equalTo(self.mas_centerY);
//            make.width.equalTo(@25);
//            make.height.equalTo(@25);
//        }];
        
        UILabel *titleLB=[[UILabel alloc] init];
        [self addSubview:titleLB];
        titleLB.text=title;
        [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@150);
            make.height.equalTo(@20);
        }];
        
        UIImageView *arrowIM=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AllowRight.png"]];
        [self addSubview:arrowIM];
        arrowIM.contentMode=UIViewContentModeScaleAspectFit;
        [arrowIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@10);
            make.height.equalTo(@15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}


@end
