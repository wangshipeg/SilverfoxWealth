

#import "BuyBlockUpTableViewCell.h"
#import "UILabel+LabelStyle.h"
#import "DateHelper.h"
#import "StringHelper.h"

@implementation BuyBlockUpTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _phoneLabel = [[UILabel alloc] init];
        [self addSubview:_phoneLabel];
        [_phoneLabel decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.height.equalTo(@15);
            make.top.equalTo(self.mas_top).offset(10);
            make.width.equalTo(@160);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        [self addSubview:_timeLabel];
        [_timeLabel decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.height.equalTo(@15);
            make.top.equalTo(_phoneLabel.mas_bottom).offset(10);
        }];
        
        _moneyLabel = [[UILabel alloc] init];
        [self addSubview:_moneyLabel];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        [_moneyLabel decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor characterBlackColor]];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@20);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        
        _lastOrderRebateLB = [[UILabel alloc] init];
        [self addSubview:_lastOrderRebateLB];
        [_lastOrderRebateLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeLabel.mas_right).offset(5);
            make.height.equalTo(@30);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(_moneyLabel.mas_left);
        }];
        _lastOrderRebateLB.hidden = YES;
    }
    return self;
}

- (void)buyBlockupWith:(DetailPageBuyBlockModel *)dic{
    if (dic) {
        if (dic.cellphone.length > 0) {
            NSString *accStr=[dic.cellphone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            _phoneLabel.text = accStr;
        }
        if ([dic.lastOrderType integerValue] == 1 || [dic.lastOrderType integerValue] == 2) {
            _lastOrderRebateLB.hidden = NO;
            _lastOrderRebateLB.attributedText = [StringHelper renderImageAndTextWithValue:[NSString stringWithFormat:@"[奖%@元现金]",dic.amount] valueFont:12 valueColor:[UIColor zheJiangBusinessRedColor] image:[UIImage imageNamed:@"LastEntry.png"] imageFrame:CGRectMake(0, -4, 12 , 15) index:0];
        }else if([dic.lastOrderType intValue] == 3){
            _lastOrderRebateLB.hidden = NO;
            _lastOrderRebateLB.attributedText = [StringHelper renderImageAndTextWithValue:[NSString stringWithFormat:@"奖%@银子",dic.amount] valueFont:12 valueColor:[UIColor zheJiangBusinessRedColor] image:[UIImage imageNamed:@"LastEntry.png"] imageFrame:CGRectMake(0, -8, 25 , 25) index:0];
        }else{
            _lastOrderRebateLB.hidden = YES;
        }
        _timeLabel.text = dic.orderTime;
        _moneyLabel.text = [NSString stringWithFormat:@"%@元",dic.principal];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
