

#import "AlreadyBuyProductCell.h"
#import "UILabel+LabelStyle.h"
#import "CalculateProductInfo.h"

@implementation AlreadyBuyProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _productNameLB=[[UILabel alloc] init];
        [self addSubview:_productNameLB];
        _productNameLB.lineBreakMode=NSLineBreakByTruncatingMiddle;
        [_productNameLB  decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:14] characterColor:[UIColor characterBlackColor]];
        [_productNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(10);
            make.height.equalTo(@15);
        }];
        
        _vipLevelImg = [[UIImageView alloc] init];
        [self addSubview:_vipLevelImg];
        [_vipLevelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_productNameLB.mas_right).offset(5);
            make.top.equalTo(_productNameLB.mas_top);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
        }];
        
        //本金
        _purchaseSumLB=[[UILabel alloc] init];
        [self addSubview:_purchaseSumLB];
        [_purchaseSumLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:14] characterColor:[UIColor zheJiangBusinessRedColor]];
        [_purchaseSumLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.productNameLB.mas_bottom).offset(10);
            make.height.equalTo(@15);
            make.width.equalTo(_productNameLB.mas_width);
        }];
        
        UILabel *capitalLB = [[UILabel alloc] init];
        [self addSubview:capitalLB];
        capitalLB.text = @"本金(元)";
        [capitalLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:13] characterColor:[UIColor depictBorderGrayColor]];
        [capitalLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.purchaseSumLB.mas_bottom);
            make.height.equalTo(@15);
            make.width.equalTo(_productNameLB.mas_width);
        }];
        
        UIImageView *imageOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayLine.png"]];
        [self addSubview:imageOne];
        imageOne.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 3 - 20, 45, 1, 15);
        
        //收益
        _thirdLB=[[UILabel alloc] init];
        [self addSubview:_thirdLB];
        _thirdLB.textAlignment=NSTextAlignmentCenter;
        [_thirdLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:14] characterColor:[UIColor zheJiangBusinessRedColor]];
        [_thirdLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(-20);
            make.top.equalTo(_purchaseSumLB.mas_top);
            make.height.equalTo(@15);
            make.width.equalTo(@80);
        }];
        
        _incomeLB =[[UILabel alloc] init];
        [self addSubview:_incomeLB];
        _incomeLB.textAlignment=NSTextAlignmentCenter;
        [_incomeLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:13] characterColor:[UIColor depictBorderGrayColor]];
        [_incomeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(-20);
            make.top.equalTo(_thirdLB.mas_bottom);
            make.height.equalTo(@15);
            make.width.equalTo(@80);
        }];
        
        UIImageView *imageTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayLine.png"]];
        [self addSubview:imageTwo];
        imageTwo.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 3 * 2 - 20, 45, 1, 15);
        
        _timeLastLB=[[UILabel alloc] init];
        [self addSubview:_timeLastLB];
        _timeLastLB.numberOfLines = 0;
        _timeLastLB.text = @"----";
        _timeLastLB.textAlignment=NSTextAlignmentRight;
        [_timeLastLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:14] characterColor:[UIColor depictBorderGrayColor]];
        [_timeLastLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-40);
            make.top.equalTo(_thirdLB.mas_top).offset(-5);
            make.height.equalTo(@43);
        }];
        
        UIImageView *arrowIM=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AllowRight.png"]];
        [self addSubview:arrowIM];
        [arrowIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@7);
            make.height.equalTo(@15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.timeLastLB.mas_centerY);
        }];

    }
    return self;
}

//显示收益中的数据
-(void)showProceedDetailWithDic:(AlreadyPurchaseProductModel *)dic
{
    self.backgroundColor=[UIColor whiteColor];
    _incomeLB.text = @"预期收益(元)";
    self.productNameLB.text = dic.productName;
    self.purchaseSumLB.text = [CalculateProductInfo calculateAlreadyProdcutNumWith:dic.principal isDouble:NO];
    self.thirdLB.text = [NSString stringWithFormat:@"%.2f",[dic.profit doubleValue]];
    if (dic.currentVipLevel.length > 0) {
        if ([dic.currentVipLevel intValue] > 0) {
            _vipLevelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"v_%@",dic.currentVipLevel]];
            _vipLevelImg.hidden = NO;
        }else{
            _vipLevelImg.hidden = YES;
        }
    } else {
        _vipLevelImg.hidden = YES;
    }
    if ([dic.interestType intValue] == 0) {
        //固定起息
        if ([dic.remainingDays intValue] < 1) {
            _timeLastLB.text = @"回款中";
            self.timeLastLB.textColor = [UIColor zheJiangBusinessRedColor];
        }else{
            self.timeLastLB.text = [NSString stringWithFormat:@"%@天\n剩余",dic.remainingDays];
            self.timeLastLB.textColor = [UIColor depictBorderGrayColor];
            //调节行间距
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_timeLastLB.text];;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:7];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _timeLastLB.text.length)];
            
            _timeLastLB.attributedText = attributedString;
            //调节高度
            CGSize size = CGSizeMake(80, 500000);
            [_timeLastLB sizeThatFits:size];
        }
    } else if ([dic.interestType intValue] == 1) {
        //T+1起息
        if ([dic.status intValue] == 1) {
            if ([dic.remainingDays intValue] > [dic.financePeriod intValue]) {
                _timeLastLB.text = @"放款中";
                self.timeLastLB.textColor = [UIColor zheJiangBusinessRedColor];
            }else if ([dic.remainingDays intValue] < 1) {
                _timeLastLB.text = @"回款中";
                self.timeLastLB.textColor = [UIColor zheJiangBusinessRedColor];
            }else{
                self.timeLastLB.text = [NSString stringWithFormat:@"%@天\n剩余",dic.remainingDays];
                self.timeLastLB.textColor = [UIColor depictBorderGrayColor];
                //调节行间距
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_timeLastLB.text];;
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                [paragraphStyle setLineSpacing:7];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _timeLastLB.text.length)];
                
                _timeLastLB.attributedText = attributedString;
                //调节高度
                CGSize size = CGSizeMake(80, 500000);
                [_timeLastLB sizeThatFits:size];
            }
        }
        if ([dic.status intValue] == 2) {
            self.timeLastLB.text = @"募集中";
            self.timeLastLB.textColor = [UIColor zheJiangBusinessRedColor];
        }
    }
}

//显示已回款的数据
- (void)showCompleteDetailWithDic:(AlreadyPurchaseProductModel *)dic
{
    self.backgroundColor=[UIColor whiteColor];
    _incomeLB.text = @"总收益(元)";
    self.productNameLB.text = dic.productName;
    self.purchaseSumLB.text = [CalculateProductInfo calculateAlreadyProdcutNumWith:[NSString stringWithFormat:@"%@",dic.principal] isDouble:NO];
    self.thirdLB.text = [NSString stringWithFormat:@"%.2f",[dic.profit doubleValue]];
    NSString *strDate = [dic.paybackDate substringToIndex:10];
    self.timeLastLB.textColor = [UIColor zheJiangBusinessRedColor];
    self.timeLastLB.text = strDate;
    if (dic.currentVipLevel.length > 0) {
        if ([dic.currentVipLevel intValue] > 0) {
            _vipLevelImg.hidden = NO;
            _vipLevelImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"v_%@",dic.currentVipLevel]];
        }else{
            _vipLevelImg.hidden = NO;
        }
    }else{
        _vipLevelImg.hidden = YES;
    }
}

//展示收益中或已回款的数据
- (void)proceedSubMenuDetailWithDic:(AlreadyPurchaseProductModel *)dic
{
    self.backgroundColor=[UIColor whiteColor];
    if ([dic.status intValue] == 3) {
        [self showCompleteDetailWithDic:dic];
    }else{
        [self showProceedDetailWithDic:dic];
    }
}


@end



