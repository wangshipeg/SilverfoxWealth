//
//  CouponDetailView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CouponDetailView.h"
#import "BackRebateActivityModel.h"
#import "SCMeasureDump.h"
#import "StringHelper.h"

@implementation CouponDetailView

- (void)setIndex:(NSInteger)index {
    _index = index;
    NSString *backgroundImage = @"", *title = @"", *backCoupon = @"",*remark = @"";
    BackRebateActivityModel *model = [SCMeasureDump shareSCMeasureDump].backRebateArray[_index];
    switch ([model.type intValue]) {
        case 1:
        {
            backgroundImage = @"silverImage";
            title = model.title;
        }
            break;
        case 2:
        {
            backgroundImage = @"silverImage";
            title = model.title;
        }
            break;
        case 3:
        {
            backgroundImage = @"couponDetailImage";
            remark = model.remark;
            title = model.title;
            backCoupon = [NSString stringWithFormat:@"%d",[model.back intValue]];
            self.couponInfoLB.font = [UIFont systemFontOfSize:13.0];
            self.amountLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:backCoupon frontFont:18 frontColor:[UIColor zheJiangBusinessRedColor] afterStr:@"元" afterFont:12 afterColor:[UIColor zheJiangBusinessRedColor]];
        }
            break;
        case 4:
        {
            backgroundImage = @"couponDetailImage";
            remark = model.remark;
            title = model.title;
            double d = [model.back doubleValue];
            NSString * testNumber = [NSString stringWithFormat:@"%f",d];
            NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
            backCoupon = [NSString stringWithFormat:@"%@%%\n(%@天)",outNumber,model.increaseDays];
            self.amountLB.text = backCoupon;
            self.amountLB.font = [UIFont systemFontOfSize:14];
            
            self.couponInfoLB.font = [UIFont systemFontOfSize:13.0];
        }
            break;
        case 5:
        {
            backgroundImage = @"couponDetailImage";
            remark = model.remark;
            title = model.title;
            backCoupon = [NSString stringWithFormat:@"%d",[model.back intValue]];
            self.couponInfoLB.font = [UIFont systemFontOfSize:18.0];
            self.amountLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:backCoupon frontFont:18 frontColor:[UIColor zheJiangBusinessRedColor] afterStr:@"元" afterFont:12 afterColor:[UIColor zheJiangBusinessRedColor]];
        }
            break;
    }
    
    self.couponImageView.image = [UIImage imageNamed:backgroundImage];
    self.couponInfoLB.text = remark;
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
