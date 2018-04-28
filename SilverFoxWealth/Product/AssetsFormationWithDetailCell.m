

#import "AssetsFormationWithDetailCell.h"
#import "UILabel+LabelStyle.h"
#import "CalculateProductInfo.h"

@implementation AssetsFormationWithDetailCell
{
    BOOL isAnimation;
    NSDecimalNumber *currentRateValue;
    NSDecimalNumber *targetRateValue;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        isAnimation = NO;
        
        _nameLB = [[UILabel alloc] init];
        [self addSubview:_nameLB];
        [_nameLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor characterBlackColor]];
        [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.height.equalTo(@25);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        _moneyLB = [[UILabel alloc] init];
        [self addSubview:_moneyLB];
        [_moneyLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor characterBlackColor]];
        [_moneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(15);
            make.height.equalTo(@25);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        //募集进度
        _progressView=[[UAProgressView alloc] init];
        [self addSubview:_progressView];
        _progressView.tintColor=[UIColor zheJiangBusinessRedColor];
        _progressView.borderWidth=2.5;
        _progressView.lineWidth=2.5;
        _progressView.fillOnTouch=NO;
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 20.0)];
        _label.textColor=[UIColor zheJiangBusinessRedColor];
        [_label setTextAlignment:NSTextAlignmentCenter];
        _label.font=[UIFont systemFontOfSize:13];
        _label.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
        self.progressView.centralView = _label;
        _progressView.progress=0;
        self.progressView.progressChangedBlock = ^(UAProgressView *progressView, CGFloat progress) {
            [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
        };
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.equalTo(@40);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (void)assetFormationWith:(AssetFormationModel *)dic
{
    _nameLB.text = dic.name;
    _moneyLB.text =[NSString stringWithFormat:@"募集金额:%@元", dic.totalAmount];

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
        centralLB.text=[NSString stringWithFormat:@"0%%"];
        return;
    }
    
    //只取小数点后两位 第三位不进位
    NSString *valueStr=[NSString stringWithFormat:@"%.2f",floor(actualAmountValue/totalAmountValue*100)];
    if (isAnimation) {
        [self animationProgressWtih:[NSString stringWithFormat:@"%.2f",[valueStr doubleValue]]];
    }else {
        [self.progressView setProgress:[valueStr doubleValue]/100];
        if ([targetRateValue doubleValue]>0) {
            targetRateValue=nil;
            currentRateValue=nil;
        }
    }
    
}

- (void)animationProgressWtih:(NSString *)progress {
    targetRateValue=[NSDecimalNumber decimalNumberWithString:progress];
    currentRateValue = [NSDecimalNumber decimalNumberWithString:@"0"];
    [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(progressChange:) userInfo:nil repeats:YES];
}

-(void)progressChange:(NSTimer *)nu {
    
    if ([currentRateValue doubleValue]==[targetRateValue doubleValue]) {
        [self.progressView setProgress:[currentRateValue doubleValue]];
        [nu invalidate];
        isAnimation=YES;
        return;
    }
    currentRateValue = [currentRateValue decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
    [self.progressView setProgress:[currentRateValue doubleValue]];
}

@end
