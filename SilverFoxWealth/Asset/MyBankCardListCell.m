//
//  MyBankCardListCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MyBankCardListCell.h"
#import "UILabel+LabelStyle.h"

@implementation MyBankCardListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headIM=[[UIImageView alloc] init];
        [self addSubview:_headIM];
        _headIM.contentMode=UIViewContentModeScaleAspectFit;
        [_headIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@25);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(15);
        }];
        
        _nameAndCardNumLB=[[UILabel alloc] init];
        [self addSubview:_nameAndCardNumLB];
        [_nameAndCardNumLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [_nameAndCardNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headIM.mas_right).offset(10);
            make.height.equalTo(@20);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-30);
        }];
    }
    return self;
}

-(void)showDetailWithDic:(BankAndIdentityInfoModel *)dic {
    
    NSString *imageStr=dic.bankNO;
    [self.headIM setImage:[UIImage imageNamed:imageStr]];
    NSString *bankNumStr=dic.cardNO;
    //只显示最后四位
    bankNumStr=[bankNumStr substringWithRange:NSMakeRange(bankNumStr.length-4, 4)];
    self.nameAndCardNumLB.text=[NSString stringWithFormat:@"%@(尾号%@)",dic.bankName,bankNumStr];
}

@end

