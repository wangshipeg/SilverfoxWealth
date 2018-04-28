//
//  ProductDetailRebateCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ProductDetailRebateCell.h"
#import "StringHelper.h"
@implementation ProductDetailRebateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"couponDetailImage.png"]];
        [self addSubview:backgroundView];
        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _moneyLB = [[UILabel alloc] init];
        _moneyLB.numberOfLines = 0;
        [_moneyLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:18] characterColor:[UIColor zheJiangBusinessRedColor]];
        [self addSubview:_moneyLB];
        [_moneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.width.equalTo(@(self.frame.size.width / 3));
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _infomationLB = [[UILabel alloc] init];
        [_infomationLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
        _infomationLB.numberOfLines = 0;
        [self addSubview:_infomationLB];
        [_infomationLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(self.frame.size.width / 3));
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}
- (void)showProductDetailRebateList:(BackRebateActivityModel *)dict
{
    NSString *backCoupon = @"";
    if ([dict.type intValue] == 3) {        
        backCoupon = [NSString stringWithFormat:@"%d",[dict.back intValue]];
        self.moneyLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:backCoupon frontFont:18 frontColor:[UIColor zheJiangBusinessRedColor] afterStr:@"元" afterFont:12 afterColor:[UIColor zheJiangBusinessRedColor]];
    }else if ([dict.type intValue] == 4){
        double d = [dict.back doubleValue];
        NSString * testNumber = [NSString stringWithFormat:@"%f",d];
        NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
        _moneyLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:[NSString stringWithFormat:@"%@%%\n",outNumber] frontFont:17 frontColor:[UIColor zheJiangBusinessRedColor] afterStr:[NSString stringWithFormat:@"(%@天)",dict.increaseDays] afterFont:12 afterColor:[UIColor zheJiangBusinessRedColor]];
    }
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:dict.remark];
    for (int i = 0; i < dict.remark.length; i ++) {
        int a = [dict.remark characterAtIndex:i];
        if (isdigit(a)) {
            [attriStr addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor zheJiangBusinessRedColor]
                                 range:NSMakeRange(i,1)];
        }
    }
    _infomationLB.attributedText = attriStr;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
