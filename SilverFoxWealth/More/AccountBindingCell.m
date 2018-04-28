//
//  AccountBindingCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AccountBindingCell.h"
#import "UILabel+LabelStyle.h"

@implementation AccountBindingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _QQOrWachatLB = [[UILabel alloc] init];
        [self addSubview:_QQOrWachatLB];
        [_QQOrWachatLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [_QQOrWachatLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@100);
            make.height.equalTo(@20);
        }];
        
        _isBindingLB=[[UILabel alloc] init];
        [self addSubview:_isBindingLB];
        [_isBindingLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [_isBindingLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
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
