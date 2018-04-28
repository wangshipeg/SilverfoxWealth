

#import "WidgetCell.h"
#import "UIColor+CustomColors.h"
#import "UILabel+LabelStyle.h"
#import "WidgetModel.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation WidgetCell

{
    // BOOL isAnimation;
    NSDecimalNumber *currentRateValue;
    NSDecimalNumber *targetRateValue;
}

#pragma -mark 初始化widget产品

- (instancetype)initWithOtherReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backView=[[UIView alloc] init];
        [self addSubview:_backView];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0)
        {
            self.backView.backgroundColor = [UIColor whiteColor];
        }
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        
        //产品名称
        _nameLb=[[UILabel alloc] init];
        _nameLb.font = [UIFont systemFontOfSize:16];
        _nameLb.textColor = [UIColor characterBlackColor];
        [_backView addSubview:_nameLb];
        
        //活动说明
        _infomationLB = [[UILabel alloc] init];
        _infomationLB.textColor = [UIColor whiteColor];
        _infomationLB.font = [UIFont systemFontOfSize:13];
        _infomationLB.backgroundColor = [UIColor yellowSilverfoxColor];
        [_backView addSubview:_infomationLB];
        _infomationLB.layer.cornerRadius = 3;
        _infomationLB.layer.masksToBounds = YES;
        
        //年收益
        _incomeLB=[[UILabel alloc] initWithFrame:CGRectMake(15, 40, 40, 20)];
        [_backView addSubview:_incomeLB];
         //自适应宽度
        _incomeLB.adjustsFontSizeToFitWidth = YES;

        
        _IM=[[UILabel alloc] initWithFrame:CGRectMake(60, 45, 45, 15)];
        _IM.font = [UIFont systemFontOfSize:13];
        _IM.textColor = [UIColor zheJiangBusinessRedColor];
        [self.backView addSubview:_IM];
        
        //理财期限
        _timeLimitLB=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, 40, 60, 15)];
        _timeLimitLB.textAlignment=NSTextAlignmentCenter;
        _timeLimitLB.textColor = [UIColor characterBlackColor];
        _timeLimitLB.font = [UIFont systemFontOfSize:16];
        [_backView addSubview:_timeLimitLB];
        
        
        //最低投资金额
        _leastInvestmentMoneyLB=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, 35, 60, 20)];
        _leastInvestmentMoneyLB.textAlignment=NSTextAlignmentCenter;
        _leastInvestmentMoneyLB.textColor = [UIColor characterBlackColor];
        _leastInvestmentMoneyLB.font = [UIFont systemFontOfSize:16];
        [_backView addSubview:_leastInvestmentMoneyLB];
        
        self.cornerIM = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, 5, 40, 40)];
        [_backView addSubview:self.cornerIM];
        
        //募集进度
        _progressView=[[UAProgressView alloc] initWithFrame:CGRectMake(_backView.frame.size.width - 75, 45, 40, 40)];
        [_backView addSubview:_progressView];
        _progressView.tintColor=[UIColor zheJiangBusinessRedColor];
        _progressView.borderWidth=2.5;
        _progressView.lineWidth=2.5;
        _progressView.fillOnTouch=NO;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 20.0)];
        label.textColor=[UIColor zheJiangBusinessRedColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.font=[UIFont systemFontOfSize:13];
        label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
        self.progressView.centralView = label;
        _progressView.progress=0;
        self.progressView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
            [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
        };
        _progressView.hidden = NO;
        
        _strusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backView.frame.size.width - 55, 50, 50, 15)];
        _strusLabel.font = [UIFont systemFontOfSize:14];
        _strusLabel.textColor = [UIColor zheJiangBusinessRedColor];
        [_backView addSubview:_strusLabel];
        _strusLabel.hidden = NO;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
        {
            self.cornerIM.frame = CGRectMake(SCREEN_WIDTH - 65, 5, 40, 40);
            _strusLabel.frame = CGRectMake(_backView.frame.size.width - 75, 50, 50, 15);
        }
        
        //年化收益
        _incomeTitleLB=[[UILabel alloc] initWithFrame:CGRectMake(15, 65, 90, 25)];
        [_backView addSubview:_incomeTitleLB];
        _incomeTitleLB.text=@"预期年化收益";
        _incomeTitleLB.textAlignment = NSTextAlignmentLeft;
        _incomeTitleLB.textColor = [UIColor characterBlackColor];
        _incomeTitleLB.font = [UIFont systemFontOfSize:14];
        
        //期限
        _timeLimitTitleLB=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30,65, 60, 25)];
        [_backView addSubview:_timeLimitTitleLB];
        _timeLimitTitleLB.textAlignment=NSTextAlignmentCenter;
        _timeLimitTitleLB.text=@"理财期限";
        _timeLimitTitleLB.textColor = [UIColor characterBlackColor];
        _timeLimitTitleLB.font = [UIFont systemFontOfSize:14];
    }
    return self;
}


//显示所有产品
-(void)showOtherDataWithDic:(WidgetModel *)dic {
    [self showAddInterestWith:dic];
    
    //产品名称
    self.nameLb.text=dic.name; 
    CGFloat width = [UILabel getWidthWithTitle:_nameLb.text font:_nameLb.font];
    _nameLb.frame = CGRectMake(15, 10, width, 15);
    //活动说明
    if (![dic.label isEqual:@""]) {
        self.infomationLB.hidden = NO;
        self.infomationLB.text = [NSString stringWithFormat:@" %@",dic.label];
    }else if([dic.label isEqual:@""])
    {
        self.infomationLB.hidden = YES;
    }
    CGFloat widthInfomation = [UILabel getWidthWithTitle:_infomationLB.text font:_nameLb.font];
    _infomationLB.frame = CGRectMake(_nameLb.frame.size.width + 15 + 10, 10, widthInfomation, 15);
    
    double d = [dic.yearIncome doubleValue];
    NSString * testNumber = [NSString stringWithFormat:@"%f",d];
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    
    //年收益
    NSMutableAttributedString *resultString=[[NSMutableAttributedString alloc] init];
    UIColor *redColor=[UIColor zheJiangBusinessRedColor];
    NSMutableAttributedString *temStr=nil;
    temStr=[[NSMutableAttributedString alloc] initWithString:outNumber attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:24],NSFontAttributeName, nil]];
    [resultString appendAttributedString:temStr];
    
    temStr=[[NSMutableAttributedString alloc] initWithString:@"%" attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:13],NSFontAttributeName, nil]];
    [resultString appendAttributedString:temStr];
    self.incomeLB.attributedText = resultString;
    
    //理财期限
    self.timeLimitLB.text=[NSString stringWithFormat:@"%lu天",(long)[dic.financePeriod integerValue]];
    
    //根据类型 定角标
    if ([dic.property isEqualToString:@"COMMON"]) {
        self.cornerIM.hidden=YES;
    }
    //根据类型 定角标
    if ([dic.property isEqualToString:@"NOVICE"]) {
        self.cornerIM.hidden=NO;
        self.cornerIM.image=[UIImage imageNamed:@"NOVICE.png"];
    }
    
    if ([dic.property isEqualToString:@"ACTIVITY"]) {
        self.cornerIM.hidden=NO;
        self.cornerIM.image=[UIImage imageNamed:@"ACTIVITY.png"];
    }
    
#pragma - mark - 如果当前时间小于上架时间  说明产品未开售
    //判断两个时间的早晚
    //将时间戳转化为字符串类型
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *rigistTime=[NSDate dateWithTimeIntervalSince1970:[dic.shippedTime longLongValue]/1000];
    NSString *dateStr=[formatter stringFromDate:rigistTime];
    NSDate *date = [[NSDate alloc] init];
    NSDate *dateTwo = [[NSDate alloc] init];
    date =[formatter dateFromString:dateStr];
    
   // NSString *dataStr = [SCMeasureDump shareSCMeasureDump].nowTime;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dataStr = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dataStr);
    
    NSDate *rigistTime2=[NSDate dateWithTimeIntervalSince1970:[dataStr longLongValue]/1000];
    NSString *dateStr2=[formatter stringFromDate:rigistTime2];
    dateTwo = [formatter dateFromString:dateStr2];
    
    _result = [dateTwo compare:date];
    if (_result < 0) {
        self.progressView.hidden = NO;
        _strusLabel.hidden = YES;
        [self.progressView setProgress:0];
        UILabel *centralLB = (UILabel *)self.progressView.centralView;
        centralLB.textColor=[UIColor zheJiangBusinessRedColor];
    
        _nameLb.textColor = [UIColor characterBlackColor];
        _incomeLB.textColor = [UIColor zheJiangBusinessRedColor];
        _timeLimitLB.textColor = [UIColor characterBlackColor];
        _timeLimitTitleLB.textColor = [UIColor characterBlackColor];
        _incomeTitleLB.textColor = [UIColor characterBlackColor];
        _IM.textColor = [UIColor zheJiangBusinessRedColor];
        _infomationLB.backgroundColor = [UIColor yellowSilverfoxColor];
        centralLB.text=@"待售";
        return;
    }
    
    //如果是通用型或活动型产品 计算是否售罄
    if ([dic.totalAmount doubleValue] <= [dic.actualAmount doubleValue] && [dic.totalAmount doubleValue] != 0) {
        self.progressView.hidden = YES;
        self.strusLabel.hidden = NO;
        //到期时间(起息时间加上理财期限)
        NSDateFormatter *dateFor=[[NSDateFormatter alloc] init];
        [dateFor setDateFormat:@"yyyyMMdd"];
        NSString *timeStr = [dic.interestDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSDate *sendDate=[dateFor dateFromString:timeStr];
        NSTimeInterval interval=([dic.financePeriod doubleValue]+1)*24*60*60;
        NSDate *toDate=[sendDate  dateByAddingTimeInterval:interval];
        NSString *incomeTimeStr=toDate.description;
        incomeTimeStr = [incomeTimeStr substringToIndex:10];
        NSString *dueTime = [incomeTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        //如果当前时间大于等于到期时间, 说明产品已经回款
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        NSString *dataStr = [dateFormatter stringFromDate:currentDate];
        NSDate *rigistTime = [NSDate dateWithTimeIntervalSince1970:[dataStr longLongValue]/1000];;
        
        NSString *dateStr=[formatter stringFromDate:rigistTime];
        if ([dateStr intValue] > [dueTime intValue] || [dateStr intValue] == [dueTime intValue]) {
            _strusLabel.text=@"已还款";
            _strusLabel.textColor = [UIColor typefaceGrayColor];
        }else{
            _strusLabel.text=@"待还款";
            _strusLabel.textColor = [UIColor zheJiangBusinessRedColor];
        }
        //售罄产品  变为灰色
        _nameLb.textColor = [UIColor typefaceGrayColor];
        _incomeLB.textColor = [UIColor typefaceGrayColor];
        _timeLimitLB.textColor = [UIColor typefaceGrayColor];
        _timeLimitTitleLB.textColor = [UIColor typefaceGrayColor];
        _incomeTitleLB.textColor = [UIColor typefaceGrayColor];
        _IM.textColor = [UIColor typefaceGrayColor];
        _infomationLB.backgroundColor = [UIColor typefaceGrayColor];
        //根据类型 定角标
        if ([dic.property isEqualToString:@"NOVICE"]) {
            self.cornerIM.hidden=NO;
            self.cornerIM.image=[UIImage imageNamed:@"NOVICEGray.png"];
        }
        
        if ([dic.property isEqualToString:@"ACTIVITY"]) {
            self.cornerIM.hidden=NO;
            self.cornerIM.image=[UIImage imageNamed:@"ACTIVITYGray.png"];
        }
        return;

    }
    _strusLabel.hidden = YES;
    _progressView.hidden = NO;
    _nameLb.textColor = [UIColor characterBlackColor];
    _incomeLB.textColor = [UIColor zheJiangBusinessRedColor];
    _timeLimitLB.textColor = [UIColor characterBlackColor];
    _timeLimitTitleLB.textColor = [UIColor characterBlackColor];
    _incomeTitleLB.textColor = [UIColor characterBlackColor];
    _IM.textColor = [UIColor zheJiangBusinessRedColor];
    _infomationLB.backgroundColor = [UIColor yellowSilverfoxColor];
    //根据类型 定角标
    if ([dic.property isEqualToString:@"NOVICE"]) {
        self.cornerIM.hidden=NO;
        self.cornerIM.image=[UIImage imageNamed:@"NOVICE.png"];
    }
    
    if ([dic.property isEqualToString:@"ACTIVITY"]) {
        self.cornerIM.hidden=NO;
        self.cornerIM.image=[UIImage imageNamed:@"ACTIVITY.png"];
    }
    
    double totalAmountValue=[dic.totalAmount doubleValue];
    double actualAmountValue=[dic.actualAmount doubleValue];
    
    UILabel *centralLB = (UILabel *)self.progressView.centralView;
    centralLB.textColor=[UIColor zheJiangBusinessRedColor];
    
    //未买
    if (actualAmountValue==0) {
        centralLB.text=[NSString stringWithFormat:@"0%%"];
        [self.progressView setProgress:0.00];
        return;
    }
    //百分比小于0.01
    if (floor(actualAmountValue/totalAmountValue*100)<1) {
        [self.progressView setProgress:0.01];
        return;
    }
    
    //只取小数点后两位 第三位不进位
    NSString *valueStr=[NSString stringWithFormat:@"%.2f",floor(actualAmountValue/totalAmountValue*100)];
    [self.progressView setProgress:[valueStr doubleValue]/100];
    if ([targetRateValue doubleValue]>0) {
        targetRateValue=nil;
        currentRateValue=nil;
    }
}

//加息 视图
- (void)showAddInterestWith:(WidgetModel *)model  {
    float interestValue = [model.increaseInterest floatValue];
    if (interestValue > 0) {
        _IM.text = [NSString stringWithFormat:@"+%@%%",model.increaseInterest];
    }else{
        _IM.text = @"";
    }
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
