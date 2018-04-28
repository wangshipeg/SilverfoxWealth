//
//  BennfitsHeaderCell.m
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BennfitsHeaderCell.h"

@implementation BennfitsHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"尊享福利"]];
        [self addSubview:iconView];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"尊享福利";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor characterBlackColor];
        [self addSubview:label];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor backgroundGrayColor];
        [self addSubview:line];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(18*default_scale);
            make.left.equalTo(self.mas_left).with.offset(132*default_scale);
            make.size.mas_equalTo(CGSizeMake(22*default_scale, 16*default_scale));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(20*default_scale);
            make.left.equalTo(iconView.mas_right).with.offset(6*default_scale);
            make.size.mas_equalTo(CGSizeMake(70*default_scale, 15*default_scale));
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(15*default_scale);
            make.right.equalTo(self.mas_right).with.offset(-15*default_scale);
            make.bottom.equalTo(self.mas_bottom).with.offset(-1);
            make.height.equalTo(@1);
        }];
        
    }
    return self;
}

@end
