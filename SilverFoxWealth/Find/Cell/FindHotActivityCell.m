//
//  FindHotActivityCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FindHotActivityCell.h"

@implementation FindHotActivityCell
- (instancetype)initWithOtherReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {        
        _phoneImg = [[UIImageView alloc] init];
        [self.contentView addSubview:_phoneImg];
        [_phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.bottom.equalTo(self.mas_bottom).offset(-25);
            make.top.equalTo(self.mas_top);
        }];
        
        _viewAlpha = [[UIView alloc] init];
        _viewAlpha.backgroundColor = [UIColor characterBlackColor];
        _viewAlpha.alpha = 0;
        [_phoneImg addSubview:_viewAlpha];
        [_viewAlpha mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_phoneImg.mas_left);
            make.right.equalTo(_phoneImg.mas_right);
            make.bottom.equalTo(_phoneImg.mas_bottom);
            make.top.equalTo(_phoneImg.mas_top);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"已结束.png"]];
        [_viewAlpha addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_phoneImg.mas_centerY);
            make.centerX.equalTo(_phoneImg.mas_centerX);
        }];
        
        _nameLB = [[UILabel alloc] init];
        _nameLB.textColor = [UIColor characterBlackColor];
        _nameLB.font = [UIFont systemFontOfSize:13];
        _nameLB.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_nameLB];
        [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.height.equalTo(@20);
            make.top.equalTo(self.phoneImg.mas_bottom);
        }];
        
        _statusLB = [[UILabel alloc] init];
        _statusLB.textColor = [UIColor zheJiangBusinessRedColor];
        _statusLB.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_statusLB];
        [_statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-5);
            make.height.equalTo(@20);
            make.top.equalTo(self.phoneImg.mas_bottom);
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
