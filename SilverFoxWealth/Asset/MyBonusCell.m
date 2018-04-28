


#import "MyBonusCell.h"
#import "StringHelper.h"
#import "UILabel+LabelStyle.h"
#import "EstimateRebateUsefulness.h"
#import "DateHelper.h"

@implementation MyBonusCell

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
        
        _amountNumLB = [[UILabel alloc] init];
        _amountNumLB.textAlignment = NSTextAlignmentLeft;
        [view addSubview:_amountNumLB];
        [_amountNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(15);
            make.centerY.equalTo(view.mas_centerY);
            make.height.equalTo(@30);
            make.width.equalTo(@95);
        }];
        
        _increaseTime = [[UILabel alloc] init];
        _increaseTime.textAlignment = NSTextAlignmentLeft;
        _increaseTime.textColor = [UIColor zheJiangBusinessRedColor];
        _increaseTime.font = [UIFont systemFontOfSize:12];
        [view addSubview:_increaseTime];
        [_increaseTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(15);
            make.top.equalTo(self.amountNumLB.mas_bottom).offset(5);
            make.height.equalTo(@20);
        }];
        
        //中间虚线
        _lineImg = [[UIImageView alloc] init];
        self.lineImg.image = [UIImage imageNamed:@"rebateLine.png"];
        [view addSubview:_lineImg];
        [_lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.amountNumLB.mas_right);
            make.top.equalTo(view.mas_top).offset(25);
            make.centerY.equalTo(view.mas_centerY);
            make.height.equalTo(@40);
            make.width.equalTo(@2);
        }];
        
        
        _rebateFromLB = [[UILabel alloc] init];
        [view addSubview:_rebateFromLB];
        [_rebateFromLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
        [_rebateFromLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lineImg.mas_right).offset(10);
            make.top.equalTo(view.mas_top).offset(15);
            make.right.equalTo(view.mas_right).offset(-15);
            make.height.equalTo(@20);
        }];
        //使用期限
        _sixtyDaysTimeLimitLB = [[UILabel alloc] init];
        [view addSubview:_sixtyDaysTimeLimitLB];
        [_sixtyDaysTimeLimitLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor depictBorderGrayColor]];
        [_sixtyDaysTimeLimitLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lineImg.mas_right).offset(10);
            make.top.equalTo(self.rebateFromLB.mas_bottom).offset(10);
            make.right.equalTo(view.mas_right);
            make.height.equalTo(@15);
        }];
        //使用条件
        _useTimeLimitLB = [[UILabel alloc] init];
        [view addSubview:_useTimeLimitLB];
        _useTimeLimitLB.numberOfLines = 0;
        [_useTimeLimitLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor depictBorderGrayColor]];
        [_useTimeLimitLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lineImg.mas_right).offset(10);
            make.top.equalTo(self.sixtyDaysTimeLimitLB.mas_bottom);
            make.right.equalTo(view.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _isPasseImg = [[UIImageView alloc] init];
        [view addSubview:_isPasseImg];
        [_isPasseImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).offset(-10);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
            make.top.equalTo(view.mas_top).offset(5);
        }];
        //使用条件
        _giveToOneLB = [[UILabel alloc] init];
        [view addSubview:_giveToOneLB];
        _giveToOneLB.text = @"转赠";
        _giveToOneLB.textAlignment = NSTextAlignmentCenter;
        [_giveToOneLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:12] characterColor:[UIColor zheJiangBusinessRedColor]];
        _giveToOneLB.layer.cornerRadius = 5;
        _giveToOneLB.layer.borderColor = [UIColor zheJiangBusinessRedColor].CGColor;
        _giveToOneLB.layer.borderWidth = 1;
        _giveToOneLB.layer.masksToBounds = YES;
        [_giveToOneLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.top.equalTo(self.mas_top).offset(15);
            make.right.equalTo(view.mas_right).offset(-10);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

- (void)showRebateDetailWith:(RebateModel *)data currentTotalTradeMoney:(NSString *)currentTotalTradeMoney {
    if ([data.donation integerValue] == 0) {
        //不可转赠
        self.userInteractionEnabled = NO;
        _giveToOneLB.hidden = YES;
    } else {
        //可转增
        self.userInteractionEnabled = YES;
        _giveToOneLB.hidden = NO;
    }
    self.rebateFromLB.text=[NSString stringWithFormat:@"%@",data.source];
    if ([data.category integerValue] >= 4) {
        double d = [data.amount doubleValue];
        NSString * testNumber = [NSString stringWithFormat:@"%f",d];
        NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
        self.amountNumLB.attributedText = [StringHelper renderCouponAmountWith:outNumber valueFont:30 yuanFont:14];
        _increaseTime.text = [NSString stringWithFormat:@"(加息%@天)", data.increaseDays];
    } else {
        self.amountNumLB.attributedText = [StringHelper renderRebateAmountWith:data.amount valueFont:30 yuanFont:14];
        if ([data.moneyLimit intValue] == 2) {
            _increaseTime.text = [NSString stringWithFormat:@"(已投资%@元)", currentTotalTradeMoney];
        } else {
            _increaseTime.text = @"";
        }
    }
    
    self.useTimeLimitLB.text = [NSString stringWithFormat:@"%@",data.condition];
    self.sixtyDaysTimeLimitLB.text = data.expiresPoint;
}

- (void)showCanNotUseRebateDetailWith:(RebateModel *)data
{
    _giveToOneLB.hidden = YES;
    self.rebateFromLB.text=[NSString stringWithFormat:@"%@",data.source];
    if ([data.category integerValue] >= 4) {
        double d = [data.amount doubleValue];
        NSString *testNumber = [NSString stringWithFormat:@"%f",d];
        NSString *outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
        self.amountNumLB.attributedText=[StringHelper renderCouponAmountWith:outNumber valueFont:38 yuanFont:18];
        _increaseTime.text = [NSString stringWithFormat:@"(加息%@天)", data.increaseDays];
    } else {
        if (data.amount.length > 3) {
            self.amountNumLB.attributedText=[StringHelper renderRebateAmountWith:data.amount valueFont:30 yuanFont:15];
        }else{
            self.amountNumLB.attributedText=[StringHelper renderRebateAmountWith:data.amount valueFont:38 yuanFont:18];
        }
        _increaseTime.text = @"";
    }
    
    self.useTimeLimitLB.text = [NSString stringWithFormat:@"%@",data.condition];
    self.sixtyDaysTimeLimitLB.text = data.expiresPoint;    
    self.rebateFromLB.textColor=[UIColor typefaceGrayColor];
    self.sixtyDaysTimeLimitLB.textColor=[UIColor typefaceGrayColor];
    self.amountNumLB.textColor = [UIColor typefaceGrayColor];
    self.useTimeLimitLB.textColor = [UIColor typefaceGrayColor];
    self.increaseTime.textColor = [UIColor typefaceGrayColor];
    self.headIM.image = [UIImage imageNamed:@"rebateGray.png"];
    self.userInteractionEnabled=NO;
    if ([data.used intValue] == 0) {
        _isPasseImg.image = [UIImage imageNamed:@"passe.png"];
    }else if ([data.used intValue] == 1){
        _isPasseImg.image = [UIImage imageNamed:@"bytesUsed.png"];
    }else{
        _isPasseImg.image = [UIImage imageNamed:@"haveDonation.png"];
    }
}


@end
