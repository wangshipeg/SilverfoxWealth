//
//  SignInPopupViewCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SignInPopupViewCell.h"

@implementation SignInPopupViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.backView=[[BlackBorderAndRoundCornerView alloc] init];
        [self addSubview:_backView];
        _backView.clipsToBounds=NO;
        _backView.backgroundColor=[UIColor whiteColor];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }];
        
        self.answerLB = [[UILabel alloc] init];
        [_backView addSubview:_answerLB];
        _answerLB.font = [UIFont systemFontOfSize:14];
        
        _answerLB.layer.borderWidth = 1.0;
        _answerLB.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor redColor]);
        _answerLB.layer.cornerRadius=5.0;
        _answerLB.layer.masksToBounds=YES;
        
        _answerLB.textColor = [UIColor characterBlackColor];
        [_answerLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView.mas_centerY);
            make.left.equalTo(_backView.mas_left).offset(15);
            make.right.equalTo(_backView.mas_right).offset(-15);
        }];
        
    }
    return self;
}
        
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
