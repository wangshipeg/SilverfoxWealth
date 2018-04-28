//
//  EarnSilverCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EarnSilverCell.h"
#import "UILabel+LabelStyle.h"

@implementation EarnSilverCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLB = [[UILabel alloc] init];
        [_nameLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [self addSubview:_nameLB];
        [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.top.equalTo(self.mas_top).offset(15);
            make.height.equalTo(@20);
        }];

        _rewardLB = [[UILabel alloc] init];
        [_rewardLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
        _rewardLB.numberOfLines = 0;
        [self addSubview:_rewardLB];
        [_rewardLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(_nameLB.mas_bottom);
            make.right.equalTo(self.mas_right).offset(-90);
            make.height.equalTo(@45);
        }];
        
        _playTaskBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playTaskBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _playTaskBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
        [self addSubview:_playTaskBT];
        _playTaskBT.titleLabel.font = [UIFont systemFontOfSize:14];
        _playTaskBT.layer.cornerRadius = 8;
        _playTaskBT.layer.masksToBounds = YES;
        [_playTaskBT addTarget:self action:@selector(clickPlayTaskBT:) forControlEvents:UIControlEventTouchUpInside];
        [_playTaskBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.rewardLB.mas_centerY);
            make.width.equalTo(@70);
            make.height.equalTo(@25);
        }];        
    }
    return self;
}

- (void)plcyTaskBlock:(PlayTaskBlock)taskBlock
{
    _taskBlock = taskBlock;
}

- (void)clickPlayTaskBT:(UIButton *)sender
{
    _taskBlock();
}
- (void)showEarnSilversDataWithDic:(EarnSilversModel *)data
{
    self.nameLB.text = data.name;
    self.rewardLB.text = [NSString stringWithFormat:@"奖励: %@",data.content];
    if ([data.idStr isEqualToString:@"1"]) {
        [self.playTaskBT setTitle:@"做任务" forState:UIControlStateNormal];
    }
    if ([data.idStr isEqualToString:@"2"]) {
        [self.playTaskBT setTitle:@"去签到" forState:UIControlStateNormal];
    }
    if ([data.idStr isEqualToString:@"3"]) {
        [self.playTaskBT setTitle:@"去分享" forState:UIControlStateNormal];
    }
    if ([data.idStr isEqualToString:@"4"]) {
        [self.playTaskBT setTitle:@"去投资" forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
