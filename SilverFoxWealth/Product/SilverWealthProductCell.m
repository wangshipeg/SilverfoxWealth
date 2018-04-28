

#import "SilverWealthProductCell.h"
#import "StringHelper.h"
#import "AnimationHelper.h"
#import "UILabel+LabelStyle.h"
#import "BlackBorderAndRoundCornerView.h"

#import "AddIncomeImageView.h"
#import "CalculateProductInfo.h"

#import "DateHelper.h"

#import "ProductDetailVC.h"
#import "SCMeasureDump.h"

#define kWidth  ([UIScreen mainScreen].bounds.size.width - 30)

@implementation SilverWealthProductCell


- (instancetype)initWithOtherReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor backgroundGrayColor];
        //isAnimation=NO;
        self.backView=[[UIView alloc] init];
        [self addSubview:_backView];
        _backView.clipsToBounds=NO;
        _backView.backgroundColor=[UIColor whiteColor];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        //产品名称
        _nameLb = [[UILabel alloc] init];
        [_nameLb decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor characterBlackColor]];
        [_backView addSubview:_nameLb];
        [_nameLb  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(15);
            make.top.equalTo(_backView.mas_top).offset(15);
            make.height.equalTo(@15);
        }];
        
        _infomationLB = [[UILabel alloc] init];
        [_infomationLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor whiteColor]];
        _infomationLB.backgroundColor = [UIColor yellowSilverfoxColor];
        [_backView addSubview:_infomationLB];
        _infomationLB.layer.cornerRadius = 3;
        _infomationLB.layer.masksToBounds = YES;
        [_infomationLB  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLb.mas_right).offset(5);
            make.top.equalTo(_backView.mas_top).offset(15);
            make.height.equalTo(@15);
        }];
        _infomationLB.adjustsFontSizeToFitWidth = YES;
        
        _lastImg = [[UIImageView alloc] init];
        [_backView addSubview:_lastImg];
        [_lastImg  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_infomationLB.mas_right).offset(10);
            make.top.equalTo(_backView.mas_top).offset(8);
            make.height.equalTo(@25);
            make.width.equalTo(@20);
        }];
        _lastImg.hidden = YES;
        
        //年收益
        _incomeLB=[[UILabel alloc] init];
        [_backView addSubview:_incomeLB];
        [_incomeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backView.mas_top).offset(45);
            make.left.equalTo(_backView.mas_left).offset(15);
            make.height.equalTo(@18);
        }];
        
        _IM=[[UILabel alloc] init];
        _IM.font = [UIFont systemFontOfSize:13];
        _IM.textColor = [UIColor zheJiangBusinessRedColor];
        [self.backView addSubview:_IM];
        [_IM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_incomeLB.mas_right);
            make.height.equalTo(@14);
            make.bottom.equalTo(_incomeLB.mas_bottom);
        }];
        
        //理财期限
        _timeLimitLB = [[UILabel alloc] init];
        _timeLimitLB.textAlignment = NSTextAlignmentCenter;
        [_timeLimitLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [_backView addSubview:_timeLimitLB];
        [_timeLimitLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backView.mas_top).offset(48);
            make.centerX.equalTo(_backView.mas_centerX);
            make.height.equalTo(@20);
            make.width.equalTo(@60);
        }];
        
        self.cornerIM = [[UIImageView alloc] init];
        [_backView addSubview:self.cornerIM];
        [_cornerIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backView.mas_top);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.height.equalTo(@35);
            make.width.equalTo(@35);
        }];
        
        //年化收益
        _incomeTitleLB=[[UILabel alloc] init];
        [_backView addSubview:_incomeTitleLB];
        _incomeTitleLB.text=@"预期年化收益";
        _incomeTitleLB.textAlignment = NSTextAlignmentLeft;
        [_incomeTitleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor depictBorderGrayColor]];
        [_incomeTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_incomeLB.mas_bottom).offset(10);
            make.left.equalTo(_backView.mas_left).offset(15);
            make.height.equalTo(@20);
            make.width.equalTo(@90);
        }];
        
        //期限
        _timeLimitTitleLB=[[UILabel alloc] init];
        [_backView addSubview:_timeLimitTitleLB];
        _timeLimitTitleLB.textAlignment=NSTextAlignmentCenter;
        _timeLimitTitleLB.text=@"理财期限";
        [_timeLimitTitleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor depictBorderGrayColor]];
        [_timeLimitTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_incomeTitleLB.mas_top);
            make.centerX.equalTo(_backView.mas_centerX);
            make.height.equalTo(@20);
            make.width.equalTo(@60);
        }];
        
        //起购金额
        _leastInvestmentMoneyTitleLB = [[UILabel alloc] init];
        [_backView addSubview:_leastInvestmentMoneyTitleLB];
        _leastInvestmentMoneyTitleLB.textAlignment=NSTextAlignmentCenter;
        _leastInvestmentMoneyTitleLB.text=@"起购金额";
        [_leastInvestmentMoneyTitleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor depictBorderGrayColor]];
        [_leastInvestmentMoneyTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_incomeTitleLB.mas_top);
            make.right.equalTo(_backView.mas_right).offset(-15);
            make.height.equalTo(@20);
            make.width.equalTo(@60);
        }];
        
        //最低投资金额
        _leastInvestmentMoneyLB=[[UILabel alloc] init];
        _leastInvestmentMoneyLB.textAlignment=NSTextAlignmentCenter;
        [_leastInvestmentMoneyLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [_backView addSubview:_leastInvestmentMoneyLB];
        [_leastInvestmentMoneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backView.mas_top).offset(48);
            make.centerX.equalTo(_leastInvestmentMoneyTitleLB.mas_centerX);
            make.height.equalTo(@20);
        }];
        
        //募集进度
        _progressLineView = [[MQGradientProgressView alloc] initWithFrame:CGRectMake(15, 100, kWidth, 1)];
        _progressLineView.colorArr = @[(id)MQRGBColor(76, 167, 238).CGColor,(id)MQRGBColor(76, 238, 228).CGColor,(id)MQRGBColor(76, 167, 238).CGColor];
        _progressLineView.backgroundColor = [UIColor colorWithRed:216 green:216 blue:216];
        [_backView addSubview:_progressLineView];
        _imageDotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProgressDot.png"]];
        [_progressLineView addSubview:_imageDotView];
        _progressLineView.progress = 0;
        _imageDotView.frame = CGRectMake(kWidth * _progressLineView.progress , -2, 8, 5);
        
        _strusLabel = [[UILabel alloc] init];
        _strusLabel.font = [UIFont systemFontOfSize:13];
        _strusLabel.textAlignment = NSTextAlignmentRight;
        _strusLabel.textColor = [UIColor zheJiangBusinessRedColor];
        [_backView addSubview:_strusLabel];
        [_strusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.width.equalTo(@60);
            make.height.equalTo(@20);
            make.right.equalTo(_backView.mas_right).offset(-15);
            make.top.equalTo(_progressLineView.mas_top).offset(10);
        }];
        
        _surplusAmountLB = [[UILabel alloc] init];
        _surplusAmountLB.font = [UIFont systemFontOfSize:13];
        _surplusAmountLB.textAlignment = NSTextAlignmentRight;
        [_backView addSubview:_surplusAmountLB];
        [_surplusAmountLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.left.equalTo(_backView.mas_left).offset(15);
            make.top.equalTo(_progressLineView.mas_top).offset(10);
        }];
    }
    return self;
}


//显示所有产品
-(void)showOtherDataWithDic:(SilverWealthProductModel *)dic {
    [self showAddInterestWith:dic];
    self.nameLb.text=dic.name;
    if (dic.label.length == 0) {
        self.infomationLB.text = nil;
    }else{
        self.infomationLB.text = [NSString stringWithFormat:@" %@ ",dic.label];
    }
    //8.8
    NSString * outNumber = [StringHelper roundValueToDoubltValue:dic.yearIncome];
    self.incomeLB.attributedText = [StringHelper renderYearIncomeWithValue:outNumber  valueFont:24 percentFont:13];
    self.timeLimitLB.text=[NSString stringWithFormat:@"%lu天",(long)[dic.financePeriod integerValue]];
    _leastInvestmentMoneyLB.text = [NSString stringWithFormat:@"%@元",dic.lowestMoney];
    NSInteger surplusAmount = [dic.totalAmount intValue] - [dic.actualAmount intValue];
    if (surplusAmount < 0) {
        surplusAmount = 0;
    }
    _surplusAmountLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"剩余可投金额  " frontFont:13 frontColor:[UIColor depictBorderGrayColor] afterStr:[NSString stringWithFormat:@"%ld元",(long)surplusAmount] afterFont:13 afterColor:[UIColor characterBlackColor]];
    if ([dic.property isEqualToString:@"COMMON"]) {
        self.cornerIM.hidden=YES;
    }
    if ([dic.property isEqualToString:@"NOVICE"]) {
        self.cornerIM.hidden=NO;
        self.cornerIM.image=[UIImage imageNamed:@"NOVICE.png"];
    }
    if ([dic.property isEqualToString:@"ACTIVITY"]) {
        self.cornerIM.hidden=NO;
        self.cornerIM.image=[UIImage imageNamed:@"ACTIVITY.png"];
    }
    if ([dic.property isEqualToString:@"EXPERIENCE"]) {
        self.cornerIM.hidden=NO;
        self.cornerIM.image=[UIImage imageNamed:@"EXPERIENCE.png"];
    }
    
#pragma - mark - 如果当前时间小于上架时间  说明产品未开售
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [[NSDate alloc] init];
    NSDate *dateTwo = [[NSDate alloc] init];
    date =[formatter dateFromString:dic.shippedTime];
    dateTwo = [formatter dateFromString:[SCMeasureDump shareSCMeasureDump].nowTime];
    _result = [dateTwo compare:date];
    if (_result < 0) {
        [self.progressLineView setProgress:0];
        _imageDotView.frame = CGRectMake(0, -2, 8, 5);
        _nameLb.textColor = [UIColor characterBlackColor];
        _incomeLB.textColor = [UIColor zheJiangBusinessRedColor];
        _timeLimitLB.textColor = [UIColor characterBlackColor];
        _timeLimitTitleLB.textColor = [UIColor depictBorderGrayColor];
        _incomeTitleLB.textColor = [UIColor depictBorderGrayColor];
        _IM.textColor = [UIColor zheJiangBusinessRedColor];
        _infomationLB.backgroundColor = [UIColor yellowSilverfoxColor];
        _leastInvestmentMoneyLB.textColor = [UIColor characterBlackColor];
        _leastInvestmentMoneyTitleLB.textColor = [UIColor depictBorderGrayColor];
        _progressLineView.colorArr = @[(id)MQRGBColor(76, 167, 238).CGColor,(id)MQRGBColor(76, 238, 228).CGColor,(id)MQRGBColor(76, 167, 238).CGColor];
        _imageDotView.image = [UIImage imageNamed:@"ProgressDot.png"];
        _strusLabel.text=@"待售";
        _strusLabel.textColor = [UIColor zheJiangBusinessRedColor];
        _lastImg.hidden = YES;
        return;
    }
    
    BOOL whether=[CalculateProductInfo calculateProdcutWhetherSelloutWith:dic];
    if (whether) {
        [self.progressLineView setProgress:1];
        _imageDotView.frame = CGRectMake(kWidth , -2, 8, 5);
        //到期时间(起息时间加上理财期限)
        NSString *timeStr = [CalculateProductInfo calculateTimeWith:dic.interestDate spaceDayTime:dic.financePeriod];
        //如果当前时间大于等于到期时间, 说明产品已经回款
        NSString *dueTime = [timeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *incomeTimeStr = [[SCMeasureDump shareSCMeasureDump].nowTime substringToIndex:10];
        NSString *dateStr = [incomeTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if ([dateStr intValue] > [dueTime intValue] || [dateStr intValue] == [dueTime intValue]) {
            _strusLabel.text=@"已还款";
        } else {
            _strusLabel.text=@"待还款";
        }
        _nameLb.textColor = [UIColor typefaceGrayColor];
        _incomeLB.textColor = [UIColor typefaceGrayColor];
        _timeLimitLB.textColor = [UIColor typefaceGrayColor];
        _timeLimitTitleLB.textColor = [UIColor typefaceGrayColor];
        _incomeTitleLB.textColor = [UIColor typefaceGrayColor];
        _IM.textColor = [UIColor typefaceGrayColor];
        _infomationLB.backgroundColor = [UIColor typefaceGrayColor];
        _leastInvestmentMoneyLB.textColor = [UIColor typefaceGrayColor];
        _leastInvestmentMoneyTitleLB.textColor = [UIColor typefaceGrayColor];
        _surplusAmountLB.textColor = [UIColor typefaceGrayColor];
        _strusLabel.textColor = [UIColor typefaceGrayColor];
        _progressLineView.colorArr = @[(id)[UIColor typefaceGrayColor].CGColor,(id)[UIColor typefaceGrayColor].CGColor,(id)[UIColor typefaceGrayColor].CGColor];
        _imageDotView.image = [UIImage imageNamed:@"GaryProgressDot.png"];
        //根据类型 定角标
        if ([dic.property isEqualToString:@"NOVICE"]) {
            self.cornerIM.hidden=NO;
            self.cornerIM.image=[UIImage imageNamed:@"NOVICEGray.png"];
        }
        
        if ([dic.property isEqualToString:@"ACTIVITY"]) {
            self.cornerIM.hidden=NO;
            self.cornerIM.image=[UIImage imageNamed:@"ACTIVITYGray.png"];
        }
        if ([dic.property isEqualToString:@"EXPERIENCE"]) {
            self.cornerIM.hidden=NO;
            self.cornerIM.image=[UIImage imageNamed:@"EXPERIENCEGray.png"];
        }
        if (dic.lastOrder.length > 0 || [dic.cashType intValue] == 1 || [dic.cashType intValue] == 2) {
            _lastImg.hidden = NO;
            _lastImg.image = [UIImage imageNamed:@"GrayLastEntry.png"];
        }else{
            _lastImg.hidden = YES;
        }
        return;
    }
    _lastImg.hidden = YES;
    _nameLb.textColor = [UIColor characterBlackColor];
    _incomeLB.textColor = [UIColor zheJiangBusinessRedColor];
    _timeLimitLB.textColor = [UIColor characterBlackColor];
    _timeLimitTitleLB.textColor = [UIColor depictBorderGrayColor];
    _incomeTitleLB.textColor = [UIColor depictBorderGrayColor];
    _IM.textColor = [UIColor zheJiangBusinessRedColor];
    _infomationLB.backgroundColor = [UIColor yellowSilverfoxColor];
    _leastInvestmentMoneyLB.textColor = [UIColor characterBlackColor];
    _leastInvestmentMoneyTitleLB.textColor = [UIColor depictBorderGrayColor];
    _strusLabel.textColor = [UIColor zheJiangBusinessRedColor];
    _progressLineView.colorArr = @[(id)MQRGBColor(76, 167, 238).CGColor,(id)MQRGBColor(76, 238, 228).CGColor,(id)MQRGBColor(76, 167, 238).CGColor];
    _imageDotView.image = [UIImage imageNamed:@"ProgressDot.png"];
    double totalAmountValue = [dic.totalAmount doubleValue];
    double actualAmountValue = [dic.actualAmount doubleValue];
    if (actualAmountValue == 0) {
        _strusLabel.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"募集进度 " frontFont:13 frontColor:[UIColor depictBorderGrayColor] afterStr:@"0%" afterFont:13 afterColor:[UIColor zheJiangBusinessRedColor]];
        [self.progressLineView setProgress:0];
        _imageDotView.frame = CGRectMake(0, -2, 8, 5);
        return;
    }
    if (floor(actualAmountValue/totalAmountValue*100) < 1) {
        _strusLabel.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"募集进度 " frontFont:13 frontColor:[UIColor depictBorderGrayColor] afterStr:@"1%" afterFont:13 afterColor:[UIColor zheJiangBusinessRedColor]];
        [self.progressLineView setProgress:0.01];
        _imageDotView.frame = CGRectMake(kWidth * 0.01 , -2, 8, 5);
        return;
    }
    
    NSString *valueStr=[NSString stringWithFormat:@"%.2f",floor(actualAmountValue/totalAmountValue*100 + 0.000001)];
    [self.progressLineView setProgress: [valueStr doubleValue] / 100];
    _strusLabel.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"募集进度 " frontFont:13 frontColor:[UIColor depictBorderGrayColor] afterStr:[NSString stringWithFormat:@"%2.0f%%", [valueStr doubleValue]] afterFont:13 afterColor:[UIColor zheJiangBusinessRedColor]];
    _imageDotView.frame = CGRectMake(kWidth * _progressLineView.progress, -2, 8, 5);
    if (!([valueStr doubleValue] < 90.0) && (dic.lastOrder.length > 0 || [dic.cashType intValue] == 1 || [dic.cashType intValue] == 2)) {
        _lastImg.hidden = NO;
        _lastImg.image = [UIImage imageNamed:@"LastEntry.png"];
    }else{
        
    }
}

- (void)showAddInterestWith:(SilverWealthProductModel *)model  {
    float interestValue = [model.increaseInterest floatValue];
    if (interestValue > 0) {
        NSString *increaseInterest = [StringHelper roundValueToDoubltValue:model.increaseInterest];
        _IM.text = [NSString stringWithFormat:@"+%@%%",increaseInterest];
    }else{
        _IM.text = @"";
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        [self.incomeLB pop_addAnimation:[AnimationHelper cellIsHighlightedAnimation] forKey:@"scaleAnimation"];
    } else {
        [self.incomeLB pop_addAnimation:[AnimationHelper cellNOHighlightedAnimation] forKey:@"scaleAnimation"];
    }
}

@end

