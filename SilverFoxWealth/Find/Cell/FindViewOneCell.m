//
//  FindViewOneCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FindViewOneCell.h"
#import "TopBottomBalckBorderView.h"

@implementation FindViewOneCell

- (instancetype)initWithOtherReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *grarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
        grarLabel.backgroundColor = [UIColor backgroundGrayColor];
        [self addSubview:grarLabel];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/ 2 - 50, 15, 100, 40)];
        label.text = @"每日必玩";
        label.textColor = [UIColor characterBlackColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        _headBTOne = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_headBTOne];
        [_headBTOne setImage:[UIImage imageNamed:@"zeroIndnvina.png"] forState:UIControlStateNormal];
        _headBTOne.titleLabel.font = [UIFont systemFontOfSize:12];
        [_headBTOne addTarget:self action:@selector(handleHeaderBTOne:) forControlEvents:UIControlEventTouchUpInside];
        [_headBTOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_centerX).offset(-2.5);
            make.top.equalTo(self.mas_top).offset(55);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        
        _headBTTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBTTwo setImage:[UIImage imageNamed:@"luckDraw.png"] forState:UIControlStateNormal];
        [self addSubview:_headBTTwo];
        _headBTTwo.titleLabel.font = [UIFont systemFontOfSize:12];
        [_headBTTwo addTarget:self action:@selector(handleHeaderBTTwo:) forControlEvents:UIControlEventTouchUpInside];
        [_headBTTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headBTOne.mas_right).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.top.equalTo(_headBTOne.mas_top);
            make.bottom.equalTo(_headBTOne.mas_centerY).offset(-2.5);
        }];
        
        _headBTThree = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBTThree setImage:[UIImage imageNamed:@"gainSilver.png"] forState:UIControlStateNormal];
        [self addSubview:_headBTThree];
        _headBTThree.titleLabel.font = [UIFont systemFontOfSize:12];
        [_headBTThree addTarget:self action:@selector(handleHeaderBTThree:) forControlEvents:UIControlEventTouchUpInside];
        [_headBTThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headBTOne.mas_right).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.top.equalTo(self.headBTTwo.mas_bottom).offset(5);
            make.bottom.equalTo(self.headBTOne.mas_bottom);
        }];
        
        _headBTOne.backgroundColor = [UIColor cyanGronudColor];
        _headBTTwo.backgroundColor = [UIColor cyanGronudColor];
        _headBTThree.backgroundColor = [UIColor cyanGronudColor];
        
        
    }
    return self;
}

- (void)zeroIndianaWith:(ZeroIndianaBlock)zeroIndianaBlock
{
    _zeroIndiana = zeroIndianaBlock;
}
- (void)luckDrawWith:(LuckDrawBlock)luckDrawBlock
{
    _luckDraw = luckDrawBlock;
}
- (void)earnSilverWith:(EarnSilverBlock)earnSilverBlock
{
    _earnSilver = earnSilverBlock;
}

- (void)handleHeaderBTOne:(UIButton *)sender
{
    _zeroIndiana();
}
- (void)handleHeaderBTTwo:(UIButton *)sender
{
    _luckDraw();
}
- (void)handleHeaderBTThree:(UIButton *)sender
{
    _earnSilver();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
