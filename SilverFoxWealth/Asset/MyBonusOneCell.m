//
//  MyBonusOneCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MyBonusOneCell.h"
#import "StringHelper.h"
#import "UILabel+LabelStyle.h"
#import "EstimateRebateUsefulness.h"

@implementation MyBonusOneCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor backgroundGrayColor];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _headIM = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CouponSide.png"]];
        [view addSubview:_headIM];
        [_headIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.width.equalTo(@5);
            make.height.equalTo(@110);
            make.centerY.equalTo(view.mas_centerY);
        }];
        
        //金额标题
        _amountTitleLB=[[UILabel alloc] init];
        [view addSubview:_amountTitleLB];
        _amountTitleLB.numberOfLines = 0;
        [_amountTitleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [_amountTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(15);
            make.centerY.equalTo(view.mas_centerY);
            make.width.equalTo(@70);
            make.height.equalTo(@100);
        }];
        
        _cumulativeLB = [[UILabel alloc] init];
        [view addSubview:_cumulativeLB];
        _cumulativeLB.text=@"------";
        [_cumulativeLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:40] characterColor:[UIColor characterBlackColor]];
        _cumulativeLB.textAlignment=NSTextAlignmentLeft;
        [_cumulativeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.amountTitleLB.mas_right).offset(35);
            make.top.equalTo(view.mas_top).offset(25);
            make.right.equalTo(view.mas_right).offset(-15);
            make.height.equalTo(@30);
        }];
        
        _useNoteLB = [[UILabel alloc] init];
        [view addSubview:_useNoteLB];
        [_useNoteLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor depictBorderGrayColor]];
        _useNoteLB.numberOfLines = 0;
        [_useNoteLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.amountTitleLB.mas_right).offset(35);
            make.top.equalTo(self.cumulativeLB.mas_bottom).offset(5);
            make.right.equalTo(view.mas_right).offset(-15);
            make.height.equalTo(@40);
        }];
    }
    return self;
}

- (void)showCumulativeRebate:(RebateModel *)data {
    //_enterDetailBlock = enterBlock;
    if ([data.donation integerValue] == 0) {
        //不可转赠
        self.userInteractionEnabled = NO;
    } else {
        //可转增
        self.userInteractionEnabled = YES;
    }
    float amount = [data.amount floatValue];
    amount = round(amount*100)/100;
    NSString *amountStr = [NSString stringWithFormat:@"%.2f",amount];
    self.cumulativeLB.attributedText = [StringHelper renderRebateAmountWith:amountStr valueFont:35 yuanFont:16];
    self.useNoteLB.text = data.condition;
    self.amountTitleLB.text = data.source;
    
    //调节行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_amountTitleLB.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_amountTitleLB.text length])];
    _amountTitleLB.attributedText = attributedString;
    [_amountTitleLB sizeToFit];
}

- (void)checkDetail:(UIButton *)sender {
    _enterDetailBlock();
}

@end








