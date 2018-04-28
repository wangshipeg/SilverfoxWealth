//
//  PopupViewCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/10/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PopupViewCell.h"
#import "StringHelper.h"

@implementation PopupViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"couponBackground.png"]];
        [self addSubview:self.backgroundImg];
        [_backgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _amountLB = [[UILabel alloc] init];
        _amountLB = [[UILabel alloc] init];
        _amountLB.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_amountLB];
        [_amountLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@30);
            make.width.equalTo(@(self.backgroundImg.frame.size.width / 3 - 15));
        }];
        
        _useLimitLB=[[UILabel alloc] init];
        _useLimitLB.numberOfLines = 0;
        _useLimitLB.font = [UIFont systemFontOfSize:13];
        _useLimitLB.textAlignment = NSTextAlignmentLeft;
        _useLimitLB.textColor = [UIColor depictBorderGrayColor];
        [self addSubview:_useLimitLB];
        
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            [_useLimitLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(self.backgroundImg.frame.size.width / 3 - 10);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@60);
                make.width.equalTo(@(self.backgroundImg.frame.size.width / 3 * 2 - 25));
            }];
        }else if([UIScreen mainScreen].bounds.size.width == 375){
            [_useLimitLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(self.backgroundImg.frame.size.width / 3 + 10);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@60);
                make.width.equalTo(@(self.backgroundImg.frame.size.width / 3 * 2 - 20));
            }];
        }else{
            [_useLimitLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(self.backgroundImg.frame.size.width / 3 + 30);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@60);
                make.width.equalTo(@(self.backgroundImg.frame.size.width / 3 * 2));
            }];
        }
    }
    return self;
}

- (void)showRebateDetailWith:(PopupModel *)data
{
    NSString * outNumber = [StringHelper roundValueToDoubltValue:data.amount];
    if ([data.category intValue] == 0) {
        self.amountLB.attributedText=[StringHelper renderRebateAmountWith:outNumber valueFont:18 yuanFont:14];
    }else{
        self.amountLB.attributedText=[StringHelper renderCouponAmountWith:outNumber valueFont:18 yuanFont:14];
    }
    self.useLimitLB.text = [NSString stringWithFormat:@"%@",data.condition];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
