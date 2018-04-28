

#import "BankCardSupportListCell.h"
#import "UILabel+LabelStyle.h"
//
//@property (strong, nonatomic) UIImageView *backIconIM;
//@property (strong, nonatomic) UILabel *backNameLB;

@implementation BankCardSupportListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //银行icon
        _backIconIM=[[UIImageView alloc] init];
        _backIconIM.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:_backIconIM];
        [_backIconIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@25);
            make.height.equalTo(@25);
        }];
        
        _backNameLB=[[UILabel alloc] init];
        [_backNameLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [self addSubview:_backNameLB];
        [_backNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backIconIM.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@70);
            make.height.equalTo(@20);
        }];
        
        _limitLB = [[UILabel alloc] init];
        [_limitLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [self addSubview:_limitLB];
        [_limitLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backNameLB.mas_right).offset(20);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

-(void)giveValueWithDic:(SupportBankModel *)dic {
    self.backNameLB.text=dic.bankName;
    [self.backIconIM setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",dic.serialNO]]];
    
    if ([dic.enable intValue] == 4) {
        _limitLB.text = @"维护中";
    }else{
        NSArray *components = [dic.remark componentsSeparatedByString:@"/"];
        NSString *singleStr = (NSString *)[components objectAtIndex:0];
        NSString *everyDayStr = (NSString *)[components objectAtIndex:1];
        if ([singleStr intValue] < 10000) {
            singleStr = [NSString stringWithFormat:@"%@元",singleStr];
        }else{
            singleStr = [NSString stringWithFormat:@"%d万",[singleStr intValue] / 10000];
        }
        if ([everyDayStr intValue] < 10000) {
            everyDayStr = [NSString stringWithFormat:@"%@元",everyDayStr];
        }else{
            everyDayStr = [NSString stringWithFormat:@"%d万",[everyDayStr intValue] / 10000];
        }
        _limitLB.text = [NSString stringWithFormat:@"单笔%@/单日%@",singleStr,everyDayStr];
    }
}


@end
