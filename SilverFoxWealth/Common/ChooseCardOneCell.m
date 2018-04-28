

#import "ChooseCardOneCell.h"
#import "UILabel+LabelStyle.h"
#import "StringHelper.h"

@implementation ChooseCardOneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _bankIconIM=[[UIImageView alloc] init];
        [self addSubview:_bankIconIM];
        [_bankIconIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.width.equalTo(@25);
            make.height.equalTo(@25);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        _cardNameLB=[[UILabel alloc] init];
        [self addSubview:_cardNameLB];
        _cardNameLB.numberOfLines = 0;
        [_cardNameLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor iconBlueColor]];
        [_cardNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.width.equalTo(@180);
            make.height.equalTo(@45);
            make.left.equalTo(self.mas_left).offset(50);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

-(void)setCellWith:(BankAndIdentityInfoModel *)dic {
    
    [self.bankIconIM setImage:[UIImage imageNamed:dic.bankNO]];
    NSString *bankNumStr = dic.cardNO;
    bankNumStr=[bankNumStr substringWithRange:NSMakeRange(bankNumStr.length-4, 4)];
    
    NSString *singleStr = nil;
    NSString *everyDayStr = nil;
    if ([dic.singleLimit intValue] < 10000) {
        singleStr = [NSString stringWithFormat:@"%@元",dic.singleLimit];
    }else{
        singleStr = [NSString stringWithFormat:@"%d万",[dic.singleLimit intValue] / 10000];
    }
    if ([dic.dayLimit intValue] < 10000) {
        everyDayStr = [NSString stringWithFormat:@"%@元",dic.dayLimit];
    }else{
        everyDayStr = [NSString stringWithFormat:@"%d万",[dic.dayLimit intValue] / 10000];
    }
    NSString *limitSftr = [NSString stringWithFormat:@"单笔%@/单日%@",singleStr,everyDayStr];
    
    _cardNameLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:[NSString stringWithFormat:@"%@ (尾号%@)\n",dic.bankName,bankNumStr] frontFont:16 frontColor:[UIColor iconBlueColor] afterStr:limitSftr afterFont:13 afterColor:[UIColor characterBlackColor]];
}

@end
